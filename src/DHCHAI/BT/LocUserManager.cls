/// 名称: DHCHAI.BT.LocUserManager
/// 描述: 科室用户关联表
/// 编写者: 刘贞贺
/// 编写日期: 2022-09-22
Class DHCHAI.BT.LocUserManager Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 系统用户指针
Property BTUserDr As DHCHAI.BT.SysUser [ Required ];

/// 用户科室指针
Property BTLocDr As DHCHAI.BT.Location [ Required ];

/// 用户在科室中的角色
Property BTRole As DHCHAI.BT.Dictionary;

/// 角色所属模块
Property BTModel As DHCHAI.BT.Dictionary;

/// 生效日期
Property BTEffectDate As %Date;

/// 失效日期
Property BTExpiryDate As %Date;

/// 是否有效
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 科室用户索引 唯一性索引,方便插入数据
Index IndexLocUserDr On (BTLocDr, BTUserDr) [ Unique ];

/// Creator：     liuzhenhe
/// CreatDate：   2022-09-22
/// Description:  根据ID取用户科室关系
/// Table：       DHCHAI.BT.LocUserManager
/// Input：       aId 
/// Return：      返回obj
/// w ##class(DHCHAI.BT.LocUserManager).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.LocUserManager
{
    New (aId)
    Quit:'##class(DHCHAI.BT.LocUserManager).%ExistsId(aId) ""
    Set obj=##Class(DHCHAI.BT.LocUserManager).%OpenId(aId)
    Do:obj'="" obj.%Close()
    Quit obj
}

/// Creator：     liuzhenhe
/// CreatDate：   2022-09-22
/// Description:  更新用户科室关系
/// Table：       DHCHAI.BT.LocUserManager
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.LocUserManager).Update("1^1^434^1^18602842018^^^1^^^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
    New (aInputStr,aSeparete)
    Set return=0
    Quit:aInputStr="" return
    
    //Set (ID,BTUserDr,BTLocDr,BTRole,BTModel,BTEffectDate,BTExpiryDate,BTIsActive,BTActDate,BTActTime,BTActUserDr)=""
    Set ID = $p(aInputStr,aSeparete,1)
    Set BTUserDr = $p(aInputStr,aSeparete,2)
    Set BTLocDr = $p(aInputStr,aSeparete,3)
    Set BTRole = $p(aInputStr,aSeparete,4)
    Set BTModel= $p(aInputStr,aSeparete,5)
    Set BTEffectDate = $p(aInputStr,aSeparete,6)
    Set BTExpiryDate = $p(aInputStr,aSeparete,7)
    Set BTIsActive = $p(aInputStr,aSeparete,8)
    Set BTActDate = $p(aInputStr,aSeparete,9)
    Set BTActTime = $p(aInputStr,aSeparete,10)
    Set BTActUserDr = $p(aInputStr,aSeparete,11)
    Set:BTEffectDate'="" BTEffectDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(BTEffectDate)
    Set:BTExpiryDate'="" BTExpiryDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(BTExpiryDate)
    Set:BTActDate'="" BTActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(BTActDate)
    Set:BTActTime[":" BTActTime = $zth(BTActTime,1)
    Set:BTActDate="" BTActDate=+$h
    Set:BTActTime="" BTActTime=$p($h,",",2)
    Quit:(BTUserDr="")||(BTLocDr="") return
    If $d(^MA.HAI.BT.LocUserManagerI("IndexLocUserDr",BTLocDr,BTUserDr)) {
        Set tId=$o(^MA.HAI.BT.LocUserManagerI("IndexLocUserDr",BTLocDr,BTUserDr,""))
        Set:tId'="" ID=tId 
    }
    b ;2
    if (ID=""){
        Set obj=##class(DHCHAI.BT.LocUserManager).%New()
    }else{
        Set obj=##class(DHCHAI.BT.LocUserManager).%OpenId(+ID)
    }
    Set objUser=##class(DHCHAI.BT.SysUser).GetObjById(BTUserDr)
    Set objLoc=##class(DHCHAI.BT.Location).GetObjById(BTLocDr)
    
    Set objRole=##class(DHCHAI.BT.Dictionary).GetObjById(BTRole)
    Set objModel=##class(DHCHAI.BT.Dictionary).GetObjById(BTModel)
    Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(BTActUserDr)
    Set obj.BTUserDr=objUser
    Set obj.BTLocDr=objLoc
    Set obj.BTRole=objRole
    Set obj.BTModel=objModel
    Set obj.BTEffectDate=BTEffectDate
    Set obj.BTExpiryDate=BTExpiryDate
    Set obj.BTIsActive=BTIsActive
    Set obj.BTActDate=BTActDate
    Set obj.BTActTime=BTActTime
    Set obj.BTActUserDr=objActUser
    
    Set sc=obj.%Save()
    if $system.Status.IsError(sc) {        //检查Save是否成功
        Do $system.OBJ.DisplayError(sc)
        Set return=-1
    }else{
        Set return=obj.%Id()
    }
    Do obj.%Close()
    
    Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2022-09-22
/// Description:  删除用户科室关系
/// Table：       DHCHAI.BT.LocUserManager
/// Input：       aId 
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.LocUserManager).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
    New (aId)
    Set sc = ##class(DHCHAI.BT.LocUserManager).%DeleteId(aId)
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
<Data name="LocUserManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTUserDr</Value>
</Value>
<Value name="3">
<Value>BTLocDr</Value>
</Value>
<Value name="4">
<Value>BTRole</Value>
</Value>
<Value name="5">
<Value>BTModel</Value>
</Value>
<Value name="6">
<Value>BTEffectDate</Value>
</Value>
<Value name="7">
<Value>BTExpiryDate</Value>
</Value>
<Value name="8">
<Value>BTIsActive</Value>
</Value>
<Value name="9">
<Value>BTActDate</Value>
</Value>
<Value name="10">
<Value>BTActTime</Value>
</Value>
<Value name="11">
<Value>BTActUserDr</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.BT.LocUserManagerD</DataLocation>
<DefaultData>LocUserManagerDefaultData</DefaultData>
<IdLocation>^MA.HAI.BT.LocUserManagerD</IdLocation>
<IndexLocation>^MA.HAI.BT.LocUserManagerI</IndexLocation>
<StreamLocation>^MA.HAI.BT.LocUserManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
