/// 名称: DHCHAI.IR.CCItmMast
/// 描述: 监控项目定义
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.CCItmMast Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目代码
Property CCCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目名称
Property CCDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 是否有效
Property CCIsActive As %Boolean;

/// 更新日期
Property CCActDate As %Date;

/// 更新时间
Property CCActTime As %Time;

/// 更新人
Property CCActUserDr As DHCHAI.BT.SysUser;

Index IdxofCode On CCCode As Exact;

/// Creator：     chenjb
/// CreatDate：   2017-01-17
/// Description:  根据ID取监控项目定义
/// Table：       DHCHAI.IR.CCItmMast
/// Input：       aId : DHCHAI.IR.CCItmMast.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCItmMast).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCItmMast
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CCItmMast).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CCItmMast).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  根据Code取监控项目定义
/// Table：       DHCHAI.IR.CCItmMast
/// Input：       aCode : DHCHAI.IR.CCItmMast.CCCode
/// Return：      返回Obj
/// w ##class(DHCHAI.IR.CCItmMast).GetObjByCode("CS1")
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.IR.CCItmMast
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^DHCHAI.IR.CCItmMastI("IdxofCode",aCode,0))
	Set obj=..GetObjById(ID)
	Quit:'$IsObject(obj) return
	Quit:obj.CCIsActive'=1 return
	Set return=obj
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-01-17
/// Description:  更新监控项目定义
/// Table：       DHCHAI.IR.CCItmMast
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCItmMast).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID          = $p(aInputStr,aSeparete,1)
	Set Code        = $p(aInputStr,aSeparete,2)
	Set Desc        = $p(aInputStr,aSeparete,3)
	Set IsActive    = +$p(aInputStr,aSeparete,4)
	Set ActDate     = $p(aInputStr,aSeparete,5)
	Set ActTime     = $p(aInputStr,aSeparete,6)
	Set ActUserDr   = $p(aInputStr,aSeparete,7)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	Set tID=$o(^DHCHAI.IR.CCItmMastI("IdxofCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCItmMast).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCItmMast).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.CCCode        = Code
	Set obj.CCDesc        = Desc
	Set obj.CCIsActive    = IsActive
	Set obj.CCActDate     = ActDate
	Set obj.CCActTime     = ActTime
	Set obj.CCActUserDr   = objActUser
	
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

/// Creator：     chenjb
/// CreatDate：   2017-01-17
/// Description:  删除监控项目定义
/// Table：       DHCHAI.IR.CCItmMast
/// Input：       aId : DHCHAI.IR.CCItmMast.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCItmMast).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.IR.CCItmMast")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.IR.CCItmMast).%DeleteId(aId)
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
<Data name="CCItmMastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CCCode</Value>
</Value>
<Value name="3">
<Value>CCDesc</Value>
</Value>
<Value name="4">
<Value>CCIsActive</Value>
</Value>
<Value name="5">
<Value>CCActDate</Value>
</Value>
<Value name="6">
<Value>CCActTime</Value>
</Value>
<Value name="7">
<Value>CCActUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCItmMastD</DataLocation>
<DefaultData>CCItmMastDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCItmMastD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCItmMastI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCItmMastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
