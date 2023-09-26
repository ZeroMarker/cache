/// 名称: DHCHAI.DP.VAEICUPeep
/// 描述: 患者PEEP、FiO2表
/// 编写者: zhoubo
/// 编写日期: 2022-01-24
Class DHCHAI.DP.VAEICUPeep Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property EpisodeDr As DHCHAI.DP.PAAdm;

/// 重症系统ID
Property ICUOrderID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 结果类型PEEP或FiO2
Property ResultType As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 结果值
Property Result As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 是否有效
Property RstIsActive As %Boolean;

/// 记录日期
Property ResultDate As %Date;

/// 记录时间
Property ResultTime As %Time;

/// 记录人
Property RegUser As %String(MAXLEN = 200, TRUNCATE = 1);

/// 结果类型索引
Index IndexType On ResultType As Exact;

/// 就诊ID+结果类型索引
Index IndexEpisType On (EpisodeDr As Exact, ResultType As Exact);

/// 就诊ID+重症系统ID索引
Index IndexEpisICU On (EpisodeDr As Exact, ICUOrderID As Exact);

/// 就诊ID+结果类型+日期索引
Index IndexEpisTypeDate On (EpisodeDr As Exact, ResultType As Exact, ResultDate As Exact);

/// Creator：     zhoubo
/// CreatDate：   2022-01-24
/// Description:  根据ID取患者PEEP、FiO2表
/// Table：       DHCHAI.DP.VAEICUPeep
/// Input：       aId : DHCHAI.DP.VAEICUPeep.ID
/// Return：      返回obj
/// w ##class(DHCHAI.DP.VAEICUPeep).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.VAEICUPeep
{
	New (aId)
	Quit:'##class(DHCHAI.DP.VAEICUPeep).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.DP.VAEICUPeep).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-01-24
/// Description:  更新患者PEEP、FiO2表
/// Table：       DHCHAI.DP.VAEICUPeep
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.VAEICUPeep).Update("^1^1^PEEP^56^1^^^med","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		    = $p(aInputStr,aSeparete,1)
	Set EpisodeDr   = $p(aInputStr,aSeparete,2)
	Set ICUOrderID  = $p(aInputStr,aSeparete,3)
	Set ResultType  = $p(aInputStr,aSeparete,4)
	Set Result      = $p(aInputStr,aSeparete,5)
	Set RstIsActive = +$p(aInputStr,aSeparete,6)
	Set ResultDate  = $p(aInputStr,aSeparete,7)
	Set ResultTime  = $p(aInputStr,aSeparete,8)
	Set RegUser     = $p(aInputStr,aSeparete,9)
	
	Quit:(ICUOrderID="")||(ResultType="") return
	
	Set:ResultDate'="" ResultDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ResultDate)
	Set:ResultDate="" ResultDate=+$h
	Set:ResultTime[":" ResultTime = $zth(ResultTime,1)
	Set:ResultTime="" ResultTime=$p($h,",",2)
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:objAdm="" return
	
	Set:ID="" ID=$o(^DHCHAI.DP.VAEICUPeepI("IndexEpisICU",EpisodeDr,ICUOrderID,0))
	If ID="" {
		Set obj=##class(DHCHAI.DP.VAEICUPeep).%New()
	}Else{
		Set obj=##class(DHCHAI.DP.VAEICUPeep).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EpisodeDr   = objAdm
	Set obj.ICUOrderID  = ICUOrderID
	Set obj.ResultType  = ResultType
	Set obj.Result      = Result
	Set obj.RstIsActive = RstIsActive
	Set obj.ResultDate	= ResultDate
	Set obj.ResultTime  = ResultTime
	Set obj.RegUser     = RegUser
	
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
/// CreatDate：   2022-01-24
/// Description:  删除患者PEEP、FiO2表
/// Table：       DHCHAI.DP.VAEICUPeep
/// Input：       aId : DHCHAI.DP.VAEICUPeep.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.DP.VAEICUPeep).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.DP.VAEICUPeep).%DeleteId(aId)
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
<Data name="VAEICUPeepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeDr</Value>
</Value>
<Value name="3">
<Value>ICUOrderID</Value>
</Value>
<Value name="4">
<Value>ResultType</Value>
</Value>
<Value name="5">
<Value>Result</Value>
</Value>
<Value name="6">
<Value>RstIsActive</Value>
</Value>
<Value name="7">
<Value>ResultDate</Value>
</Value>
<Value name="8">
<Value>ResultTime</Value>
</Value>
<Value name="9">
<Value>RegUser</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.VAEICUPeepD</DataLocation>
<DefaultData>VAEICUPeepDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.VAEICUPeepD</IdLocation>
<IndexLocation>^DHCHAI.DP.VAEICUPeepI</IndexLocation>
<StreamLocation>^DHCHAI.DP.VAEICUPeepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
