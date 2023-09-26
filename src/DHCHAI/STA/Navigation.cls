/// 名称: DHCHAI.STA.Navigation
/// 描述: 统计指标导航
/// 编写者：pylian
/// 编写日期: 2017-08-22
Class DHCHAI.STA.Navigation Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 指标代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 指标名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 指向报表代码
Property BTStatCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 指向报表名称
Property BTStatDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 排序码
Property BTIndNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 算法
Property BTMethod As %String(MAXLEN = 500, TRUNCATE = 1);

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUserDr As DHCHAI.BT.SysUser;

Index IndexCode On BTCode As Exact;

/// Creator：     pylian
/// CreatDate：   2017-08-22
/// Description:  根据ID取统计指标导航信息
/// Table：       DHCHAI.STA.Navigation
/// Input：       aId : DHCHAI.STA.Navigation.ID
/// Return：      返回obj
/// w ##class(DHCHAI.STA.Navigation).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.STA.Navigation
{
	New (aId)
	Quit:'##class(DHCHAI.STA.Navigation).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.STA.Navigation).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2017-08-22
/// Description:  更新统计指标导航信息
/// Table：       DHCHAI.STA.Navigation
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.STA.Navigation).Update("^IIHAI-1^医院感染发病率^DHCHAI.Sta.001.raq^1-医院感染发病（例次）率^1^医院感染发病率 = 新发生医院感染的患者人数/同期住院患者人数×100%^^1","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set StatCode = $p(aInputStr,aSeparete,4)
	Set StatDesc = $p(aInputStr,aSeparete,5)
	Set IndNo    = $p(aInputStr,aSeparete,6)
	Set Method   = $p(aInputStr,aSeparete,7)
	Set ActDate  = $p(aInputStr,aSeparete,8)
	Set ActTime  = $p(aInputStr,aSeparete,9)
	Set ActUserDr= $p(aInputStr,aSeparete,10)
	Quit:(Code="")||(Desc="") return
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	Set tID=$o(^DHCHAI.STA.NavigationI("IndexCode",Code,0))
    //Quit:(tID'="")&(ID'=tID) -2
    Set:(tID'="")&(ID="") ID=tID
	If ID="" {
		Set obj=##class(DHCHAI.STA.Navigation).%New()
	}Else{
		Set obj=##class(DHCHAI.STA.Navigation).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTStatCode = StatCode
	Set obj.BTStatDesc = StatDesc
	Set obj.BTIndNo    = IndNo
	Set obj.BTMethod   = Method
	Set obj.BTActDate  = ActDate
	Set obj.BTActTime  = ActTime
	Set obj.BTActUserDr= objActUser
	
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

/// Creator：     pylian
/// CreatDate：   2017-08-22
/// Description:  删除统计指标导航信息
/// Table：       DHCHAI.STA.Navigation
/// Input：       aId : DHCHAI.STA.Navigation.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.STA.Navigation).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.STA.Navigation).%DeleteId(aId)
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
<Data name="NavigationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTStatCode</Value>
</Value>
<Value name="5">
<Value>BTStatDesc</Value>
</Value>
<Value name="6">
<Value>BTIndNo</Value>
</Value>
<Value name="7">
<Value>BTMethod</Value>
</Value>
<Value name="8">
<Value>BTActDate</Value>
</Value>
<Value name="9">
<Value>BTActTime</Value>
</Value>
<Value name="10">
<Value>BTActUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.STA.NavigationD</DataLocation>
<DefaultData>NavigationDefaultData</DefaultData>
<IdLocation>^DHCHAI.STA.NavigationD</IdLocation>
<IndexLocation>^DHCHAI.STA.NavigationI</IndexLocation>
<StreamLocation>^DHCHAI.STA.NavigationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
