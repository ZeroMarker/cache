/// 名称: DHCHAI.IR.CCScreenDtl
/// 描述: 疑似病例筛查结果列表
/// 编写者：zhufei
/// 编写日期: 2017-05-27
Class DHCHAI.IR.CCScreenDtl Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.CCScreening [ Cardinality = parent, Inverse = ChildDtl ];

/// 操作状态（1确诊、2排除）
Property CSStatus As %Integer;

/// 结果日期 (即为 DHCHAI.IR.CCScreening的CSRstToDate)
Property CSRstDate As %Date;

/// 上报感染部位（诊断）
Property CSInfRepPosDr As DHCHAI.IR.INFDiagnos;

/// 操作日期
Property CSActDate As %Date;

/// 操作时间
Property CSActTime As %Time;

/// 操作人
Property CSActUserDr As DHCHAI.BT.SysUser;

Index IndexInfRepPosDr On CSInfRepPosDr;

Index IndexActDateTime On (CSActDate, CSActTime);

/// Creator：     pylian
/// CreatDate：   2019-07-15
/// Description:  根据ID疑似病例筛查结果
/// Table：       DHCHAI.IR.CCScreenDtl
/// Input：       DHCHAI.IR.CCScreenDtl.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCScreenDtl).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCScreenDtl
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.CCScreenDtl).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2019-07-15
/// Description:  更新疑似病例筛查结果
/// Table：       DHCHAI.IR.CCScreenDtl
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.CCScreenDtl).Update("18^^28^^^32","^")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=""
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Quit:(aSeparete="") return
	
	Set Parref      = $p(aInput,aSeparete,1)
	Set ChildSub    = $p(aInput,aSeparete,2)
	Set Status      = $p(aInput,aSeparete,3)
	Set RstDate     = $p(aInput,aSeparete,4)
	Set InfRepPosDr = $p(aInput,aSeparete,5)
	Set ActDate     = $p(aInput,aSeparete,6)
	Set ActTime     = $p(aInput,aSeparete,7)
	Set ActUserDr   = $p(aInput,aSeparete,8)
	Quit:(Parref="")||(Status="")||(RstDate="") return
	
	Set objParref = ##class(DHCHAI.IR.CCScreening).GetObjById(Parref)
	Set objInfRepPos = ##class(DHCHAI.IR.INFDiagnos).GetObjById(InfRepPosDr)
    Set:RstDate'="" RstDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RstDate)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h   //当前日期
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	If ChildSub="" {
		Set obj=##class(DHCHAI.IR.CCScreenDtl).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCHAI.IR.CCScreenDtl).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.Parref        = objParref
	Set obj.CSStatus      = Status
	Set obj.CSRstDate     = RstDate
	Set obj.CSInfRepPosDr = objInfRepPos
	Set obj.CSActDate     = ActDate
	Set obj.CSActTime     = ActTime
	Set obj.CSActUserDr   = objActUser
		
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

/// Creator：     pylian
/// CreatDate：   2019-07-15
/// Description:  删除疑似病例筛查结果
/// Table：       DHCHAI.IR.CCScreenDtl
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.CCScreenDtl).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CCScreenDtl).%DeleteId(aId)
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
<Data name="CCScreenDtlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSStatus</Value>
</Value>
<Value name="3">
<Value>CSRstDate</Value>
</Value>
<Value name="4">
<Value>CSInfRepPosDr</Value>
</Value>
<Value name="5">
<Value>CSActDate</Value>
</Value>
<Value name="6">
<Value>CSActTime</Value>
</Value>
<Value name="7">
<Value>CSActUserDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Dtl")</DataLocation>
<DefaultData>CCScreenDtlDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Dtl")</IdLocation>
<IndexLocation>^DHCHAI.IR.CCScreeningI("Dtl")</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCScreenDtlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
