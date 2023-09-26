/// 名称: DHCHAI.BT.LocationMap
/// 描述: 科室对照列表
/// 编写者：zhufei
/// 编写日期: 2017-09-30
Class DHCHAI.BT.LocationMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 科室指针
Property BTMapLocDr As DHCHAI.BT.Location [ Required ];

/// 科室代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 科室名称
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 子系统代码
Property BTSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 科室关联码
Property BTXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 子系统代码 + 科室关联码索引
Index IndexSCodeXCode On (BTSCode As Exact, BTXCode As Exact);

/// 子系统代码 + 科室代码索引
Index IndexSCodeCode On (BTSCode As Exact, BTCode As Exact);

/// 子系统代码 + 科室名称索引
Index IndexSCodeDesc On (BTSCode As Exact, BTDesc As Exact);

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  根据Code取对照科室关系
/// Table：       DHCHAI.BT.LocationMap
/// Input：       aSCode : DHCHAI.BT.LocationMap.BTSCode
///               aXCode : DHCHAI.BT.LocationMap.BTCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.LocationMap).GetObjByCode(1)
ClassMethod GetObjByCode(aSCode As %String, aCode As %String) As DHCHAI.BT.Location
{
	New (aSCode,aCode)
	Set return = ""
	Quit:(aSCode="")||(aCode="") return
	
	Set aSCode=$zcvt(aSCode,"U")
	Set aCode=$zcvt(aCode,"U")
	Set ID=$o(^DHCHAI.BT.LocationMapI("IndexSCodeCode",aSCode,aCode,0))
	If ID="" {
		Set HISCode=""
		Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
		Set:$IsObject(objSYS) HISCode=objSYS.BTHISCode
		If (HISCode'="")&(HISCode'=aSCode) {
			Set ID=$o(^DHCHAI.BT.LocationMapI("IndexSCodeCode",HISCode,aCode,0))
		}
	}
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  根据XCode取对照科室关系
/// Table：       DHCHAI.BT.LocationMap
/// Input：       aSCode : DHCHAI.BT.LocationMap.BTSCode
///               aXCode : DHCHAI.BT.LocationMap.BTXCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.LocationMap).GetObjByXCode(1)
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.BT.Location
{
	New (aSCode,aXCode)
	Set return = ""
	Quit:(aSCode="")||(aXCode="") return
	
	Set aSCode=$zcvt(aSCode,"U")
	Set aXCode=$zcvt(aXCode,"U")
	Set ID=$o(^DHCHAI.BT.LocationMapI("IndexSCodeXCode",aSCode,aXCode,0))
	If ID="" {
		Set HISCode=""
		Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
		Set:$IsObject(objSYS) HISCode=objSYS.BTHISCode
		If (HISCode'="")&(HISCode'=aSCode) {
			Set ID=$o(^DHCHAI.BT.LocationMapI("IndexSCodeXCode",HISCode,aXCode,0))
		}
	}
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  根据ID取科室信息
/// Table：       DHCHAI.BT.LocationMap
/// Input：       aId : DHCHAI.BT.LocationMap.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.LocationMap).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.LocationMap
{
	New (aId)
	Quit:'##class(DHCHAI.BT.LocationMap).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.LocationMap).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  更新科室信息
/// Table：       DHCHAI.BT.LocationMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.LocationMap).Update()
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(aInputStr,aSeparete,1)
	Set MapLocDr    = $p(aInputStr,aSeparete,2)
	Set Code        = $p(aInputStr,aSeparete,3)
	Set Desc        = $p(aInputStr,aSeparete,4)
	Set SCode       = $p(aInputStr,aSeparete,5)
	Set XCode   	= $p(aInputStr,aSeparete,6)
	Set ActDate   	= $p(aInputStr,aSeparete,7)
	Set ActTime   	= $p(aInputStr,aSeparete,8)
	Set ActUserDr   = $p(aInputStr,aSeparete,9)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(SCode="")||(XCode="") return
	
	Set Code=$zcvt(Code,"U")
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set SCode=$zcvt(SCode,"U")
	Set XCode=$zcvt(XCode,"U")
	Set tID=$o(^DHCHAI.BT.LocationMapI("IndexSCodeXCode",SCode,XCode,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(MapLocDr)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.LocationMap).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.LocationMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTMapLocDr  = objLoc
	Set obj.BTCode	    = Code
	Set obj.BTDesc	    = Desc
	Set obj.BTSCode	    = SCode
	Set obj.BTXCode		= XCode
	Set obj.BTActDate	= ActDate
	Set obj.BTActTime	= ActTime
	Set obj.BTActUserDr	= objActUser
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

Storage Default
{
<Data name="LocationMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTMapLocDr</Value>
</Value>
<Value name="3">
<Value>BTCode</Value>
</Value>
<Value name="4">
<Value>BTDesc</Value>
</Value>
<Value name="5">
<Value>BTSCode</Value>
</Value>
<Value name="6">
<Value>BTXCode</Value>
</Value>
<Value name="7">
<Value>BTActDate</Value>
</Value>
<Value name="8">
<Value>BTActTime</Value>
</Value>
<Value name="9">
<Value>BTActUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.LocationMapD</DataLocation>
<DefaultData>LocationMapDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.LocationMapD</IdLocation>
<IndexLocation>^DHCHAI.BT.LocationMapI</IndexLocation>
<StreamLocation>^DHCHAI.BT.LocationMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
