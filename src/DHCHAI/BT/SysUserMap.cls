/// 名称: DHCHAI.BT.SysUserMap
/// 描述: 用户对照列表
/// 编写者：zhufei
/// 编写日期: 2017-09-30
Class DHCHAI.BT.SysUserMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 用户指针
Property BTMapUserDr As DHCHAI.BT.SysUser [ Required ];

/// 用户代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 用户名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 用户关联码
Property BTXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 子系统代码
Property BTSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 子系统代码 + 用户关联码索引
Index IndexSCodeXCode On (BTSCode As Exact, BTXCode As Exact);

/// 子系统代码 + 用户代码索引
Index IndexSCodeCode On (BTSCode As Exact, BTCode As Exact);

/// 子系统代码 + 用户名称索引
Index IndexSCodeDesc On (BTSCode As Exact, BTDesc As Exact);

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  根据Code取对照用户关系
/// Table：       DHCHAI.BT.SysUserMap
/// Input：       aSCode : DHCHAI.BT.SysUserMap.BTSCode
///               aXCode : DHCHAI.BT.SysUserMap.BTCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.SysUserMap).GetObjByCode(1)
ClassMethod GetObjByCode(aSCode As %String, aCode As %String) As DHCHAI.BT.SysUser
{
	New (aSCode,aCode)
	Set return = ""
	Quit:(aSCode="")||(aCode="") return
	
	Set aSCode=$zcvt(aSCode,"U")
	Set aCode=$zcvt(aCode,"U")
	Set ID=$o(^DHCHAI.BT.SysUserMapI("IndexSCodeCode",aSCode,aCode,""),-1)	//倒序取最新数据
	
	If ID="" {
		Set HISCode=""
		Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
		Set:$IsObject(objSYS) HISCode=objSYS.BTHISCode
		If (HISCode'="")&(HISCode'=aSCode) {
			Set ID=$o(^DHCHAI.BT.SysUserMapI("IndexSCodeCode",HISCode,aCode,""),-1)	//倒序取最新数据
		}
	}
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  根据XCode取对照用户关系
/// Table：       DHCHAI.BT.SysUserMap
/// Input：       aSCode : DHCHAI.BT.SysUserMap.BTSCode
///               aXCode : DHCHAI.BT.SysUserMap.BTXCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.SysUserMap).GetObjByXCode(1)
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.BT.SysUser
{
	New (aSCode,aXCode)
	Set return = ""
	Quit:(aSCode="")||(aXCode="") return
	
	Set aSCode=$zcvt(aSCode,"U")
	Set aXCode=$zcvt(aXCode,"U")
	Set ID=$o(^DHCHAI.BT.SysUserMapI("IndexSCodeXCode",aSCode,aXCode,0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  根据ID取用户信息
/// Table：       DHCHAI.BT.SysUserMap
/// Input：       aId : DHCHAI.BT.SysUserMap.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.SysUserMap).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.SysUserMap
{
	New (aId)
	Quit:'##class(DHCHAI.BT.SysUserMap).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.SysUserMap).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  更新用户信息
/// Table：       DHCHAI.BT.SysUserMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.SysUserMap).Update()
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(aInputStr,aSeparete,1)
	Set MapUserDr   = $p(aInputStr,aSeparete,2)
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
	Set tID=$o(^DHCHAI.BT.SysUserMapI("IndexSCodeXCode",SCode,XCode,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objUser=##class(DHCHAI.BT.SysUser).GetObjById(MapUserDr)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.SysUserMap).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.SysUserMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTMapUserDr = objUser
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
<Data name="SysUserMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTMapUserDr</Value>
</Value>
<Value name="3">
<Value>BTCode</Value>
</Value>
<Value name="4">
<Value>BTDesc</Value>
</Value>
<Value name="5">
<Value>BTXCode</Value>
</Value>
<Value name="6">
<Value>BTSCode</Value>
</Value>
<Value name="7">
<Value>BTActDate</Value>
</Value>
<Value name="8">
<Value>BTActTime</Value>
</Value>
<Value name="9">
<Value>BTActUser</Value>
</Value>
<Value name="10">
<Value>BTActUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.SysUserMapD</DataLocation>
<DefaultData>SysUserMapDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.SysUserMapD</IdLocation>
<IndexLocation>^DHCHAI.BT.SysUserMapI</IndexLocation>
<StreamLocation>^DHCHAI.BT.SysUserMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
