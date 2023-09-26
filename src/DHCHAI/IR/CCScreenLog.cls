/// 名称: DHCHAI.IR.CCScreenLog
/// 描述: 疑似病例筛查操作日志
/// 编写者：zhufei
/// 编写日期: 2017-05-27
Class DHCHAI.IR.CCScreenLog Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.CCScreening [ Cardinality = parent, Inverse = ChildLog ];

/// 疑似状态（1确诊、2排除、0未处理）
Property CSStatus As %Integer;

/// 疑似诊断（部位）
Property CSInfSuPosDr As DHCHAI.BT.InfSuPos;

/// 处置日期
Property CSActDate As %Date;

/// 处置时间
Property CSActTime As %Time;

/// 处置人
Property CSActUserDr As DHCHAI.BT.SysUser;

/// 处置意见
Property CSOpinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 处置意见字典
Property CSOpinionDr As DHCHAI.BT.Dictionary;

/// 处置人类型（1：临床，2：院感科）
Property CSActType As %String;

Index IndexActDateTime On (CSActDate, CSActTime);

/// Creator：     chenjb
/// CreatDate：   2017-06-10
/// Description:  疑似监控项目处置日志
/// Table：       DHCHAI.IR.CCScreenLog
/// Input：       DHCHAI.IR.CCScreenLog.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCScreenLog).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCScreenLog
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.CCScreenLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2017-06-10
/// Description:  疑似监控项目处置日志
/// Table：       DHCHAI.IR.CCScreenLog
/// Input：       "^"分隔
/// 1 Parref 2 CSStatus 3 CSInfSuPosDr 4 CSActUserDr 5 CSOpinion
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.CCScreenLog).Update("","")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=""
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Quit:(aSeparete="") return
	
	Set obj=##Class(DHCHAI.IR.CCScreenLog).%New()   //每次都是新增
	Set Parref=$p(aInput,aSeparete,1)
	Set obj.Parref=##class(DHCHAI.IR.CCScreening).GetObjById(Parref)
	Set obj.CSStatus=$p(aInput,aSeparete,2)
	Set CSInfSuPosDr =$p(aInput,aSeparete,3)
	Set obj.CSInfSuPosDr=##class(DHCHAI.BT.InfSuPos).GetObjById(CSInfSuPosDr)
	Set obj.CSActDate=+$h
	Set obj.CSActTime=$p($h,",",2)
	Set CSActUserDr=$p(aInput,aSeparete,4)
	Set obj.CSActUserDr=##class(DHCHAI.BT.SysUser).GetObjById(CSActUserDr)
	Set obj.CSOpinion=$p(aInput,aSeparete,5)
	Set OpinionDr=$p(aInput,aSeparete,6)
	Set obj.CSOpinionDr=##class(DHCHAI.BT.Dictionary).GetObjById(OpinionDr)
	Set obj.CSActType =$p(aInput,aSeparete,7)	
	
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
<Data name="CCScreenLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSStatus</Value>
</Value>
<Value name="3">
<Value>CSInfSuPosDr</Value>
</Value>
<Value name="4">
<Value>CSActDate</Value>
</Value>
<Value name="5">
<Value>CSActTime</Value>
</Value>
<Value name="6">
<Value>CSActUserDr</Value>
</Value>
<Value name="7">
<Value>CSOpinion</Value>
</Value>
<Value name="8">
<Value>CSOpinionDr</Value>
</Value>
<Value name="9">
<Value>CSActType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Log")</DataLocation>
<DefaultData>CCScreenLogDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Log")</IdLocation>
<IndexLocation>^DHCHAI.IR.CCScreeningI("Log")</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCScreenLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
