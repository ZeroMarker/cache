/// 名称: DHCHAI.IR.VAESubItem
/// 描述: VAE监测项目子项定义
/// 编写者: zhoubo
/// 编写日期: 2022-01-12
Class DHCHAI.IR.VAESubItem Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 子项代码
Property VASItmCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 子项名称
Property VASItmDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 子项说明
Property VASResume As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 是否有效
Property VASIsActive As %Boolean;

/// 更新日期
Property VASActDate As %Date;

/// 更新时间
Property VASActTime As %Time;

/// 更新人
Property VASActUserDr As DHCHAI.BT.SysUser;

Index IndexCode On VASItmCode As Exact;

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  根据ID取VAE监测项目子项
/// Table：       DHCHAI.IR.VAESubItem
/// Input：       aId : DHCHAI.IR.VAESubItem.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.VAESubItem).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.VAESubItem
{
	New (aId)
	Quit:'##class(DHCHAI.IR.VAESubItem).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.VAESubItem).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-18
/// Description:  根据Code取VAE监测项目子项
/// Table：       DHCHAI.IR.VAESubItem
/// Input：       aCode : DHCHAI.IR.VAESubItem.BTCode
/// Return：      返回String
/// w ##class(DHCHAI.IR.VAESubItem).GetIDByCode("6")
ClassMethod GetIDByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return

	Set ID=$o(^CT.MA.HAI.IR.VAESubItemI("IndexCode",aCode,0))
	Set obj=..GetObjById(ID)
	If $IsObject(obj) {
		Set return=ID
	}
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  更新VAE监测项目子项
/// Table：       DHCHAI.IR.VAESubItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAESubItem).Update("^6^PEEP(呼吸末正压)^每日最低PEEP保持稳定或较降低≥ {2} 天，之后连续 {2} 天较前两天内升高≥ {3}^1^^^1","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			 = $p(aInputStr,aSeparete,1)
	Set VASItmCode    = $p(aInputStr,aSeparete,2)
	Set VASItmDesc    = $p(aInputStr,aSeparete,3)
	Set VASResume     = $p(aInputStr,aSeparete,4)
	Set VASIsActive   = +$p(aInputStr,aSeparete,5)
	Set VASActDate    = $p(aInputStr,aSeparete,6)
	Set VASActTime    = $p(aInputStr,aSeparete,7)
	Set VASActUserDr  = $p(aInputStr,aSeparete,8)
	
	
	Quit:(VASItmCode="")||(VASItmDesc="") return
	Set VASResume = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(VASResume)  //去掉特殊字符
	
	Set:VASActDate'="" VASActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(VASActDate)
	Set:VASActDate="" VASActDate=+$h
	Set:VASActTime[":" VASActTime = $zth(VASActTime,1)
	Set:VASActTime="" VASActTime=$p($h,",",2)
	Set ObjUser=##class(DHCHAI.BT.SysUser).GetObjById(VASActUserDr)
	
	Set:ID="" ID=$o(^CT.MA.HAI.IR.VAESubItemI("IndexCode",VASItmCode,0))
	If ID="" {
		Set obj=##class(DHCHAI.IR.VAESubItem).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.VAESubItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.VASItmCode   = VASItmCode
	Set obj.VASItmDesc   = VASItmDesc
	Set obj.VASResume    = VASResume
	Set obj.VASIsActive  = VASIsActive
	Set obj.VASActDate   = VASActDate
	Set obj.VASActTime	 = VASActTime
	Set obj.VASActUserDr = ObjUser
	
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

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  删除VAE监测项目子项
/// Table：       DHCHAI.IR.VAESubItem
/// Input：       aId : DHCHAI.IR.VAESubItem.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAESubItem).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.VAESubItem).%DeleteId(aId)
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
<Data name="VAESubItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VASItmCode</Value>
</Value>
<Value name="3">
<Value>VASItmDesc</Value>
</Value>
<Value name="4">
<Value>VASResume</Value>
</Value>
<Value name="5">
<Value>VASIsActive</Value>
</Value>
<Value name="6">
<Value>VASActDate</Value>
</Value>
<Value name="7">
<Value>VASActTime</Value>
</Value>
<Value name="8">
<Value>VASActUserDr</Value>
</Value>
</Data>
<DataLocation>^CT.MA.HAI.IR.VAESubItemD</DataLocation>
<DefaultData>VAESubItemDefaultData</DefaultData>
<IdLocation>^CT.MA.HAI.IR.VAESubItemD</IdLocation>
<IndexLocation>^CT.MA.HAI.IR.VAESubItemI</IndexLocation>
<StreamLocation>^CT.MA.HAI.IR.VAESubItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
