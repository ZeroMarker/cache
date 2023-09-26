/// 名称: DHCHAI.IR.VAEMonitItem
/// 描述: VAE监测项目定义
/// 编写者: zhoubo
/// 编写日期: 2022-01-12
Class DHCHAI.IR.VAEMonitItem Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目代码
Property VAItmCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目名称
Property VAItmDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 项目说明
Property VAResume As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 医院
Property VAHospDr As DHCHAI.BT.Hospital;

/// 是否有效
Property VAIsActive As %Boolean;

/// 更新日期
Property VAActDate As %Date;

/// 更新时间
Property VAActTime As %Time;

/// 更新人
Property VAActUserDr As DHCHAI.BT.SysUser;

Index IndexCode On VAItmCode As Exact;

/// Creator：     zhoubo
/// CreatDate：   2022-03-14
/// Description:  根据Code取项目定义
/// Table：       DHCHAI.IR.VAEMonitItem
/// Input：       aCode : DHCHAI.IR.VAEMonitItem.CCCode
/// Return：      返回Obj
/// w ##class(DHCHAI.IR.VAEMonitItem).GetObjByCode("VAC")
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.IR.VAEMonitItem
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^CT.MA.HAI.IR.VAEMonitItemI("IndexCode",aCode,0))
	Set obj=..GetObjById(ID)
	Quit:'$IsObject(obj) return
	Quit:obj.VAIsActive'=1 return
	Set return=obj
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  根据ID取VAE监测项目
/// Table：       DHCHAI.IR.VAEMonitItem
/// Input：       aId : DHCHAI.IR.VAEMonitItem.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.VAEMonitItem).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.VAEMonitItem
{
	New (aId)
	Quit:'##class(DHCHAI.IR.VAEMonitItem).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.VAEMonitItem).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  更新VAE监测项目
/// Table：       DHCHAI.IR.VAEMonitItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAEMonitItem).Update("^1^VAC标准^每日最低PEEP保持稳定或较降低≥2天，之后连续2天较前两天内升高≥3或每日最低FiO2保持稳定或较降低≥2天，之后连续2天较前两天内升高≥20%^1^1^^^1","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			 = $p(aInputStr,aSeparete,1)
	Set VAItmCode    = $p(aInputStr,aSeparete,2)
	Set VAItmDesc    = $p(aInputStr,aSeparete,3)
	Set VAResume     = $p(aInputStr,aSeparete,4)
	Set VAHospDr     = $p(aInputStr,aSeparete,5)
	Set VAIsActive   = +$p(aInputStr,aSeparete,6)
	Set VAActDate    = $p(aInputStr,aSeparete,7)
	Set VAActTime    = $p(aInputStr,aSeparete,8)
	Set VAActUserDr  = $p(aInputStr,aSeparete,9)
	
	
	Quit:(VAItmCode="")||(VAItmDesc="") return
	Set VAResume = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(VAResume)  //去掉特殊字符
	
	Set:VAActDate'="" VAActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(VAActDate)
	Set:VAActDate="" VAActDate=+$h
	Set:VAActTime[":" VAActTime = $zth(VAActTime,1)
	Set:VAActTime="" VAActTime=$p($h,",",2)
	Set ObjUser=##class(DHCHAI.BT.SysUser).GetObjById(VAActUserDr)
	Set ObjHosp=##class(DHCHAI.BT.Hospital).GetObjById(VAHospDr)
	
	Set:ID="" ID=$o(^CT.MA.HAI.IR.VAEMonitItemI("IndexCode",VAItmCode,0))
	If ID="" {
		Set obj=##class(DHCHAI.IR.VAEMonitItem).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.VAEMonitItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.VAItmCode   = VAItmCode
	Set obj.VAItmDesc   = VAItmDesc
	Set obj.VAResume    = VAResume
	Set obj.VAHospDr    = ObjHosp
	Set obj.VAIsActive  = VAIsActive
	Set obj.VAActDate   = VAActDate
	Set obj.VAActTime	= VAActTime
	Set obj.VAActUserDr = ObjUser
	
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
/// Description:  删除VAE监测项目
/// Table：       DHCHAI.IR.VAEMonitItem
/// Input：       aId : DHCHAI.IR.VAEMonitItem.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.VAEMonitItem).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.VAEMonitItem).%DeleteId(aId)
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
<Data name="VAEMonitItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VAItmCode</Value>
</Value>
<Value name="3">
<Value>VAItmDesc</Value>
</Value>
<Value name="4">
<Value>VAResume</Value>
</Value>
<Value name="5">
<Value>VAHospDr</Value>
</Value>
<Value name="6">
<Value>VAIsActive</Value>
</Value>
<Value name="7">
<Value>VAActDate</Value>
</Value>
<Value name="8">
<Value>VAActTime</Value>
</Value>
<Value name="9">
<Value>VAActUserDr</Value>
</Value>
</Data>
<DataLocation>^CT.MA.HAI.IR.VAEMonitItemD</DataLocation>
<DefaultData>VAEMonitItemDefaultData</DefaultData>
<IdLocation>^CT.MA.HAI.IR.VAEMonitItemD</IdLocation>
<IndexLocation>^CT.MA.HAI.IR.VAEMonitItemI</IndexLocation>
<StreamLocation>^CT.MA.HAI.IR.VAEMonitItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
