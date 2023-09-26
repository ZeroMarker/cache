/// 名称: DHCHAI.IR.CCLocGroup
/// 描述: 院感科工作科室分组
/// 编写者：zhoubo
/// 编写日期: 2018-01-05
Class DHCHAI.IR.CCLocGroup Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 科室
Property CCLocDr As DHCHAI.BT.Location;

/// 责任人类型("CCLocGroupType")
Property CCLocGroupDr As DHCHAI.BT.Dictionary;

/// 责任人
Property CCLocUser As DHCHAI.BT.SysUser;

/// 生效日期
Property BTEffectDate As %Date;

/// 失效日期
Property BTExpiryDate As %Date;

/// 是否有效
Property BTIsActive As %Boolean;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 更新人
Property UpdateUserDr As DHCHAI.BT.SysUser;

/// 科室
Index IndexLoc On CCLocDr;

/// 科室+类型
Index IndexLocType On (CCLocDr, CCLocGroupDr);

/// 责任人+类型
Index IndexUserGroup On (CCLocUser, CCLocGroupDr);

/// 分组+ 科室 +责任人
Index IndexGroupLocUser On (CCLocGroupDr, CCLocDr, CCLocUser);

/// Creator：     zhoubo
/// CreatDate：   2018-01-05
/// Description:  根据ID取院感科工作科室分组
/// Table：       DHCHAI.IR.CCLocGroup
/// Input：       aId : DHCHAI.IR.CCLocGroup.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCLocGroup).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCLocGroup
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CCLocGroup).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CCLocGroup).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2018-01-05
/// Description:  根据科室ID取科室分组
/// Table：       DHCHAI.IR.CCLocGroup
/// Input：       科室ID   LocID
/// Return：      返回科室分组
/// w ##class(DHCHAI.IR.CCLocGroup).GetLocGrpByLocType(675,"爆发预警工作分组")
ClassMethod GetLocGrpByLocType(aLocID As %String, aGrpType As %String) As %String
{
	new (aLocID,aGrpType)
	set return="其他科"
	quit:(aLocID="")||(aGrpType="") return
	
	Set aGrpTypeDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("CCLocGroupType",aGrpType,"1")
	Quit:aGrpTypeDr="" return
	Set ID=$o(^DHCHAI.IR.CCLocGroupI("IndexLocType",aLocID,aGrpTypeDr,0))
	Quit:ID="" return
	Set obj=##class(DHCHAI.IR.CCLocGroup).GetObjById(ID)
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.CCLocUser) return
	Set return=obj.CCLocUser.BTDesc
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-01-05
/// Description:  更新院感科工作科室分组
/// Table：       DHCHAI.IR.CCLocGroup
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCLocGroup).Update("^6^孙艳芳^^^4","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID           = $p(aInputStr,aSeparete,1)
	Set LocDr	     = $p(aInputStr,aSeparete,2)
	Set GroupDr      = $p(aInputStr,aSeparete,3)
	Set LocUser      = $p(aInputStr,aSeparete,4)
	Set UpdateDate   = $p(aInputStr,aSeparete,5)
	Set UpdateTime   = $p(aInputStr,aSeparete,6)
	Set UpdateUserDr = $p(aInputStr,aSeparete,7)
    Set EffectDate = $p(aInputStr,aSeparete,8)
    Set ExpiryDate = $p(aInputStr,aSeparete,9)
    Set IsActive = $p(aInputStr,aSeparete,10)
	Quit:(LocDr="")||(GroupDr="") return
	Set UpdateDate=+$h
	Set UpdateTime=$p($h,",",2)
	Set objLocUser=##class(DHCHAI.BT.SysUser).GetObjById(LocUser)
	Quit:'$IsObject(objLocUser) return
	Set objGroupDr =##class(DHCHAI.BT.Dictionary).GetObjById(GroupDr)
	Set objUser=##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)
	Quit:'$IsObject(objUser) return
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Quit:'$IsObject(objLoc) return
    Set:EffectDate'="" EffectDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(EffectDate)
    Set:ExpiryDate'="" ExpiryDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ExpiryDate)
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCLocGroup).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCLocGroup).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.CCLocDr      = objLoc
	Set obj.CCLocGroupDr = objGroupDr
	Set obj.CCLocUser    = objLocUser
	Set obj.UpdateDate   = UpdateDate
	Set obj.UpdateTime   = UpdateTime
	Set obj.UpdateUserDr = objUser
	
    Set obj.BTEffectDate=EffectDate
    Set obj.BTExpiryDate=ExpiryDate
    Set obj.BTIsActive=IsActive
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

/// Creator：     zhoubo
/// CreatDate：   2018-01-05
/// Description:  删除院感科工作科室分组
/// Table：       DHCHAI.IR.CCLocGroup
/// Input：       aId : DHCHAI.IR.CCLocGroup.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCLocGroup).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CCLocGroup).%DeleteId(aId)
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
<Data name="CCLocGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CCLocDr</Value>
</Value>
<Value name="3">
<Value>CCLocGroupDr</Value>
</Value>
<Value name="4">
<Value>CCLocUser</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
<Value name="6">
<Value>UpdateTime</Value>
</Value>
<Value name="7">
<Value>UpdateUserDr</Value>
</Value>
<Value name="8">
<Value>BTEffectDate</Value>
</Value>
<Value name="9">
<Value>BTExpiryDate</Value>
</Value>
<Value name="10">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCLocGroupD</DataLocation>
<DefaultData>CCLocGroupDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCLocGroupD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCLocGroupI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCLocGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
