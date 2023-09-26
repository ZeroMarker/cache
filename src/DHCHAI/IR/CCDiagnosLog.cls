/// 名称: DHCHAI.IR.CCDiagnosLog
/// 描述: 患者出院感染诊断处置记录 更新日志
/// 编写者：zhoubo
/// 编写日期: 2018-03-29
Class DHCHAI.IR.CCDiagnosLog Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.CCDiagnos [ Cardinality = parent, Inverse = ChildLog ];

/// 操作状态(1确诊、2疑似、3排除)
Property IRStatus As %Integer;

/// 操作意见
Property IROpinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 更新日期
Property IRUpdateDate As %Date;

/// 更新时间
Property IRUpdateTime As %Time;

/// 更新人
Property IRUpdateUserDr As DHCHAI.BT.SysUser;

/// Creator：     zhoubo
/// CreatDate：   2018-03-29
/// Description:  处置日志
/// Table：       DHCHAI.IR.CCDiagnosLog
/// Input：       DHCHAI.IR.CCDiagnosLog.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCDiagnosLog).GetObjById("1||1")
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCDiagnosLog
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.CCDiagnosLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2018-03-29
/// Description:  更新日志
/// Table：       DHCHAI.IR.CCDiagnosLog
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.CCDiagnosLog).Update("1^1^dfdfdf^12","")
ClassMethod Update(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=""

	Set:$g(aSeparate)="" aSeparate=..#SEPARATE
	Quit:(aSeparate="") return
	Set obj=##Class(DHCHAI.IR.CCDiagnosLog).%New()   //每次都是新增
	
	Set Parref        = $p(aInput,aSeparate,1)
	Set obj.Parref    = ##class(DHCHAI.IR.CCDiagnos).GetObjById(Parref)
	Set IRStatus      = $p(aInput,aSeparate,2)
	Set obj.IROpinion = $p(aInput,aSeparate,3)
	Set obj.IRUpdateDate=+$h
	Set obj.IRUpdateTime=$p($h,",",2)
	Set IRUpdateUserDr = $p(aInput,aSeparate,4)
	Set obj.IRUpdateUserDr=##class(DHCHAI.BT.SysUser).GetObjById(IRUpdateUserDr)
	
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

Storage Default
{
<Data name="CCDiagnosLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRStatus</Value>
</Value>
<Value name="3">
<Value>IROpinion</Value>
</Value>
<Value name="4">
<Value>IRUpdateDate</Value>
</Value>
<Value name="5">
<Value>IRUpdateTime</Value>
</Value>
<Value name="6">
<Value>IRUpdateUserDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("LOG")</DataLocation>
<DefaultData>CCDiagnosLogDefaultData</DefaultData>
<IdLocation>{%%PARENT}("LOG")</IdLocation>
<IndexLocation>^DHCHAI.IR.CCDiagnosI("LOG")</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCDiagnosLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
