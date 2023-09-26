/// 名称: DHCHAI.IR.CCDiagnos
/// 描述: 患者出院感染诊断
/// 编写者：zhoubo
/// 编写日期: 2018-03-29
Class DHCHAI.IR.CCDiagnos Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 更新日志
Relationship ChildLog As DHCHAI.IR.CCDiagnosLog [ Cardinality = children, Inverse = Parref ];

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 处置状态(1确诊、2疑似、3排除)
Property IRStatus As %Integer;

/// 处置意见
Property IROpinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 处置日期
Property IRActDate As %Date;

/// 处置时间
Property IRActTime As %Time;

/// 处置人
Property IRActUserDr As DHCHAI.BT.SysUser;

Index IndexEpisodeDr On IREpisodeDr;

/// Creator：     zhoubo
/// CreatDate：   2018-03-29
/// Description:  根据ID取患者出院感染诊断处置记录
/// Table：       DHCHAI.IR.CCDiagnos
/// Input：       Id : DHCHAI.IR.CCDiagnos.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCDiagnos).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCDiagnos
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CCDiagnos).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CCDiagnos).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2018-03-29
/// Description:  更新患者出院感染诊断处置记录
/// Table：       DHCHAI.IR.CCDiagnos
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCDiagnos).Update("^23^1^sdgergseg^^^1","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID              = $p(aInputStr,aSeparete,1)
	Set IREpisodeDr     = $p(aInputStr,aSeparete,2)
	Set IRStatus        = $p(aInputStr,aSeparete,3)
	Set IROpinion       = $p(aInputStr,aSeparete,4)
	Set IRActDate       = $p(aInputStr,aSeparete,5)     // 更新日期
	Set IRActTime       = $p(aInputStr,aSeparete,6)     // 更新时间
	Set IRActUserDr     = $p(aInputStr,aSeparete,7)     // 更新人
	Set:IRActDate="" IRActDate = +$h
	Set:IRActTime="" IRActTime = $p($h,",",2)
	
	Quit:(IREpisodeDr="")||(IRStatus="") return
	
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(IREpisodeDr)
	Quit:'$IsObject(objAdm) return
	
	Set tID=$o(^DHCHAI.IR.CCDiagnosI("IndexEpisodeDr",IREpisodeDr,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCDiagnos).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CCDiagnos).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IREpisodeDr = objAdm
	Set obj.IRStatus    = IRStatus
	Set obj.IROpinion   = IROpinion
	Set obj.IRActDate   = IRActDate
	Set obj.IRActTime   = IRActTime
	Set obj.IRActUserDr = ##class(DHCHAI.BT.SysUser).GetObjById(IRActUserDr)
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
		Set ret = ##class(DHCHAI.IR.CCDiagnosLog).Update(return_"^"_IRStatus_"^"_IROpinion_"^"_IRActUserDr,"^")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-03-29
/// Description:  删除患者出院感染诊断处置记录
/// Table：       DHCHAI.IR.CCDiagnos
/// Input：       aId : DHCHAI.IR.CCDiagnos.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCDiagnos).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CCDiagnos).%DeleteId(aId)
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
<Data name="CCDiagnosDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRStatus</Value>
</Value>
<Value name="4">
<Value>IROpinion</Value>
</Value>
<Value name="5">
<Value>IRActDate</Value>
</Value>
<Value name="6">
<Value>IRActTime</Value>
</Value>
<Value name="7">
<Value>IRActUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCDiagnosD</DataLocation>
<DefaultData>CCDiagnosDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCDiagnosD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCDiagnosI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCDiagnosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
