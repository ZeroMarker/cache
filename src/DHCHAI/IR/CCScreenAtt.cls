/// 名称: DHCHAI.IR.CCScreenAtt
/// 描述: 疑似病例筛查 需关注病人列表
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.CCScreenAtt Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property CSEpisodeDr As DHCHAI.DP.PAAdm;

/// 需关注标志（1持续关注）
Property CSIsNeedAtt As %Boolean;

/// 需关注原因(txt)
Property CSIsNeedMsg As %String;

/// 总评分
Property CSScore As %String;

/// 处置日期
Property CSAttDate As %Date;

/// 处置时间
Property CSAttTime As %Time;

/// 处置人
Property CSAttUserDr As DHCHAI.BT.SysUser;

/// 疑似感染标志（1疑似病例）
Property CSIsSusInf As %Boolean;

/// 待处理标志（0待处理、1已处理）
Property CSIsSuspend As %Integer;

/// 待处理日期
Property CSSusDate As %Date;

/// 待处理时间
Property CSSusTime As %Time;

Index IndexEpisodeDr On CSEpisodeDr [ Unique ];

Index IndexAttDateTime On (CSAttDate, CSAttTime);

Index IndexNeedAttEpd On (CSIsNeedAtt, CSEpisodeDr);

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  根据ID取需关注病人信息
/// Table：       DHCHAI.IR.CCScreenAtt
/// Input：       Id : DHCHAI.IR.CCScreenAtt.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCScreenAtt).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCScreenAtt
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CCScreenAtt).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CCScreenAtt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-08-10
/// Description:  更新需关注标志
/// Table：       DHCHAI.IR.CCScreenAtt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCScreenAtt).UpdateNeedAttflag("95^1^9","")
ClassMethod UpdateNeedAttflag(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set EpisodeDr   = $p(aInputStr,aSeparete,1)
	Set IsNeedAtt   = +$p(aInputStr,aSeparete,2)
	Set IsNeedMsg   = $p(aInputStr,aSeparete,3)
	Set AttUserDr   = $p(aInputStr,aSeparete,4)
	Quit:(EpisodeDr="") return
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objEpisode) return
	
	Set ID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",EpisodeDr,0))
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCScreenAtt).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCScreenAtt).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CSEpisodeDr  = objEpisode
	Set obj.CSIsNeedAtt  = IsNeedAtt
	Set obj.CSIsNeedMsg  = IsNeedMsg
	Set obj.CSAttDate    = +$h
	Set obj.CSAttTime    = $p($h,",",2)
	Set obj.CSAttUserDr  = ##class(DHCHAI.BT.SysUser).GetObjById(AttUserDr)
	
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

/// Creator：     zhufei
/// CreatDate：   2017-08-10
/// Description:  更新疑似感染标志
/// Table：       DHCHAI.IR.CCScreenAtt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCScreenAtt).UpdateSusInfFlag("95^1^0","")
ClassMethod UpdateSusInfFlag(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set EpisodeDr = $p(aInputStr,aSeparete,1)
	Set IsSusInf  = +$p(aInputStr,aSeparete,2)
	Set IsSuspend = +$p(aInputStr,aSeparete,3)
	Set ScoreCnt  = +$p(aInputStr,aSeparete,4)
	Quit:(EpisodeDr="") return
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objEpisode) return
	
	Set ID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",EpisodeDr,0))
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCScreenAtt).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCScreenAtt).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CSEpisodeDr  = objEpisode
	Set obj.CSIsSusInf   = IsSusInf
	Set obj.CSIsSuspend  = IsSuspend
	Set obj.CSScore      = ScoreCnt
	Set obj.CSSusDate    = +$h
	Set obj.CSSusTime    = $p($h,",",2)
	
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
/// CreatDate：   2016-12-16
/// Description:  删除需关注病人信息
/// Table：       DHCHAI_IR.CCScreening
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCScreenAtt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CCScreenAtt).%DeleteId(aId)
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
<Data name="CCScreenAttDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSEpisodeDr</Value>
</Value>
<Value name="3">
<Value>CSIsNeedAtt</Value>
</Value>
<Value name="4">
<Value>CSAttDate</Value>
</Value>
<Value name="5">
<Value>CSAttTime</Value>
</Value>
<Value name="6">
<Value>CSAttUserDr</Value>
</Value>
<Value name="7">
<Value>CSIsSusInf</Value>
</Value>
<Value name="8">
<Value>CSIsSuspend</Value>
</Value>
<Value name="9">
<Value>CSSusDate</Value>
</Value>
<Value name="10">
<Value>CSSusTime</Value>
</Value>
<Value name="11">
<Value>CSIsNeedMsg</Value>
</Value>
<Value name="12">
<Value>CSScore</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCScreenAttD</DataLocation>
<DefaultData>CCScreenAttDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCScreenAttD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCScreenAttI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCScreenAttS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
