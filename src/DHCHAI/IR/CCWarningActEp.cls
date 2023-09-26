/// 名称: DHCHAI.IR.CCWarningActEp
/// 描述: 爆发预警确诊排除患者记录表
/// 编写者：chenjb
/// 编写日期: 2021-08-20
Class DHCHAI.IR.CCWarningActEp Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 确诊排除ID
Property IRWarnActID As %String(TRUNCATE = 1);

/// 处置状态(1:疑似聚集,2:散发)
Index IndexWarnActID On IRWarnActID As Exact;

/// 预警患者+主表索引
Index IndexEpisodeWarnAct On (IREpisodeDr As Exact, IRWarnActID As Exact);

/// Creator：     chenjb
/// CreatDate：   2021-08-15
/// Description:  获取对象
/// Table：       DHCHAI.IR.CCWarningActEp
/// Input：       DHCHAI.IR.CCWarningActEp.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCWarningActEp).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCWarningActEp
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.CCWarningActEp).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2021-08-17
/// Description:  更新对象
/// Table：       DHCHAI.IR.CCWarningActEp
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.CCWarningActEp).Update("^^")
ClassMethod Update(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set ID 			 = $p(aInput,aSeparate,1)
	Set IREpisodeDr  = $p(aInput,aSeparate,2)
	Set IRWarnActID  = $p(aInput,aSeparate,3)	
	
	Quit:((IREpisodeDr="")||(IRWarnActID="")) return
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(IREpisodeDr)
	Quit:'$IsObject(objEpisode) return
	//唯一索引	
	Set ID=$o(^DHCHAI.IR.CCWarningActEpI("IndexEpisodeWarnAct",IREpisodeDr,IRWarnActID,0))
	If (ID="") {
		Set obj=##class(DHCHAI.IR.CCWarningActEp).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.CCWarningActEp).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IREpisodeDr  = objEpisode
	Set obj.IRWarnActID  = IRWarnActID
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2021-08-14
/// Description:  删除对象
/// Table：       DHCHAI.IR.CCWarningActEp
/// Input：       DHCHAI.IR.CCWarningActEp.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.CCWarningAct).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCHAI.IR.CCWarningActEp).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="CCWarningActEpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRWarnActID</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCWarningActEpD</DataLocation>
<DefaultData>CCWarningActEpDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCWarningActEpD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCWarningActEpI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCWarningActEpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
