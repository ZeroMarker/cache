/// 名称: DHCHAI.IR.INFRepLog
/// 描述: 医院感染报告 更新日志
/// 编写者：zhufei
/// 编写日期: 2017-06-28
Class DHCHAI.IR.INFRepLog Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.INFReport [ Cardinality = parent, Inverse = ChildLog ];

/// 操作状态
Property IRStatusDr As DHCHAI.BT.Dictionary;

/// 操作意见
Property IROpinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 更新日期
Property IRUpdateDate As %Date;

/// 更新时间
Property IRUpdateTime As %Time;

/// 更新人
Property IRUpdateUserDr As DHCHAI.BT.SysUser;

/// Creator：     chenjb
/// CreatDate：   2017-06-10
/// Description:  报告处置日志
/// Table：       DHCHAI.IR.INFRepLog
/// Input：       DHCHAI.IR.INFRepLog.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.INFRepLog).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.INFRepLog
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.INFRepLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2017-06-10
/// Description:  报告处置日志
/// Table：       DHCHAI.IR.INFRepLog
/// Input：       "^"分隔
/// 1 Parref 2 IRStatusDr 3 IROpinion 4 IRUpdateUserDr
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportLog).Update("","")
ClassMethod Update(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=""

	Set:$g(aSeparate)="" aSeparate=..#SEPARATE
	Quit:(aSeparate="") return
	Set obj=##Class(DHCHAI.IR.INFRepLog).%New()   //每次都是新增
	Set Parref=$p(aInput,aSeparate,1)
	Set obj.Parref=##class(DHCHAI.IR.INFReport).GetObjById(Parref)
	Set IRStatusDr = $p(aInput,aSeparate,2)
	Set obj.IRStatusDr=##class(DHCHAI.BT.Dictionary).GetObjById(IRStatusDr)
	Set obj.IROpinion =$p(aInput,aSeparate,3)
	Set obj.IRUpdateDate=+$h
	Set obj.IRUpdateTime=$p($h,",",2)
	Set IRUpdateUserDr=$p(aInput,aSeparate,4)
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
<Data name="INFRepLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRStatusDr</Value>
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
<DefaultData>INFRepLogDefaultData</DefaultData>
<IdLocation>{%%PARENT}("LOG")</IdLocation>
<IndexLocation>^DHCHAI.IR.INFReportI("LOG")</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFRepLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
