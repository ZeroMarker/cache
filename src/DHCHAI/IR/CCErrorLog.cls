/// 名称: DHCHAI.IR.CCErrorLog
/// 描述: 医院感染监控错误日志
/// 编写者：zhufei
/// 编写日期: 2017-05-03
Class DHCHAI.IR.CCErrorLog Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property CCEpisodeDr As DHCHAI.DP.PAAdm;

/// 错误描述
Property CCErrNote As %String(MAXLEN = 1000, TRUNCATE = 1) [ Required ];

/// 生成日期
Property CCActDate As %Date;

/// 生成时间
Property CCActTime As %Time;

/// 执行方法
Property CCMethod As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

Index IndexEpisodeDr On CCEpisodeDr As Exact;

Index IndexDateTime On (CCActDate, CCActTime);

/// Creator：     zhufei
/// CreatDate：   2017-05-03
/// Description:  根据ID取监控错误日志
/// Table：       DHCHAI.IR.CCErrorLog
/// Input：       aId : DHCHAI.IR.CCErrorLog.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCErrorLog).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCErrorLog
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CCErrorLog).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CCErrorLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-05-03
/// Description:  更新监控错误日志
/// Table：       DHCHAI.IR.CCErrorLog
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCErrorLog).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(aInputStr,aSeparete,1)
	Set EpisodeDr   = $p(aInputStr,aSeparete,2)
	Set ErrNote     = $p(aInputStr,aSeparete,3)
	Set Method      = $p(aInputStr,aSeparete,4)
	Quit:(ErrNote="") return
    
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCErrorLog).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCErrorLog).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CCEpisodeDr  = objEpisode
	Set obj.CCErrNote    = ErrNote
	Set obj.CCActDate    = +$h
	Set obj.CCActTime    = $p($h,",",2)
	Set obj.CCMethod     = Method
	
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
/// CreatDate：   2017-05-03
/// Description:  删除监控错误日志
/// Table：       DHCHAI.IR.CCErrorLog
/// Input：       aId : DHCHAI.IR.CCErrorLog.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCErrorLog).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CCErrorLog).%DeleteId(aId)
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
<Data name="CCErrorLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CCEpisodeDr</Value>
</Value>
<Value name="3">
<Value>CCErrNote</Value>
</Value>
<Value name="4">
<Value>CCActDate</Value>
</Value>
<Value name="5">
<Value>CCActTime</Value>
</Value>
<Value name="6">
<Value>CCMethod</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCErrorLogD</DataLocation>
<DefaultData>CCErrorLogDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCErrorLogD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCErrorLogI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCErrorLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
