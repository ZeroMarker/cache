/// 名称: DHCHAI.IR.CRuleOperCat
/// 描述: 手术分类75百分位
/// 编写者：pylian
/// 编写日期: 2021-09-29
Class DHCHAI.IR.CRuleOperCatP75 Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 手术分类
Property CROperCatDr As DHCHAI.IR.CRuleOperCat [ Required ];

/// 手术时长(75百分位手术的时长)
Property CROperMin As %String [ Required ];

/// 全院
Property CRHospGrpDr As DHCHAI.BT.HospGroup;

/// 院区
Property CRHospDr As DHCHAI.BT.Hospital;

/// 手术计算起始月
Property CRStatDate As %String;

/// 手术计算截止月
Property CREndDate As %String;

/// 有效标志
Property CRIsActive As %Boolean;

/// 更新日期
Property CRActDate As %Date;

/// 更新时间
Property CRActTime As %Time;

Index IndexGOperCatDate On (CROperCatDr, CREndDate As Exact, CRHospGrpDr);

Index IndexHOperCatDate On (CROperCatDr, CREndDate As Exact, CRHospDr);

/// Creator：     pylian
/// CreatDate：   2021-09-17
/// Description:  手术分类75百分位信息
/// Table：       DHCHAI.IR.CRuleOperCatP75
/// Input：       aId : DHCHAI.IR.CRuleOperCatP75.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleOperCatP75).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleOperCat
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleOperCatP75).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleOperCatP75).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2021-09-29
/// Description:  更新手术分类75百分位信息
/// Table：       手术分类75百分位
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleOperCatP75).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID        = $p(aInputStr,aSeparete,1)
	Set OperCatDr = $p(aInputStr,aSeparete,2)
	Set OperMin   = $p(aInputStr,aSeparete,3)
	Set HospGrpDr = $p(aInputStr,aSeparete,4)
	Set HospDr    = $p(aInputStr,aSeparete,5)	
	Set StatDate  = $p(aInputStr,aSeparete,6)
	Set EndDate   = $p(aInputStr,aSeparete,7)
	Set IsActive  = +$p(aInputStr,aSeparete,8)
	Set ActDate   = $p(aInputStr,aSeparete,9)
	Set ActTime   = $p(aInputStr,aSeparete,10)	
	Quit:(OperCatDr="")||(OperMin="") return
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set objOperCat=##Class(DHCHAI.IR.CRuleOperCat).GetObjById(OperCatDr) 
	Quit:'$IsObject(objOperCat) return
	
	Set objHospGrp=##Class(DHCHAI.BT.HospGroup).GetObjById(HospGrpDr)
	Set objHosp=##Class(DHCHAI.BT.Hospital).GetObjById(HospDr)  
	
	If (HospGrpDr'="") {
		Set tID =$o(^DHCHAI.IR.CRuleOperCatP75I("IndexGOperCatDate",OperCatDr,EndDate,HospGrpDr,0))
	}Else {
		Set tID =$o(^DHCHAI.IR.CRuleOperCatP75I("IndexHOperCatDate",OperCatDr,EndDate,HospDr,0))
	}
    Set:(ID="")&(tID'="") ID=tID
	If ID="" {
		Set obj=##class(DHCHAI.IR.CRuleOperCatP75).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleOperCatP75).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CROperCatDr   = objOperCat
	Set obj.CROperMin     = OperMin
	Set obj.CRHospGrpDr   = objHospGrp
	Set obj.CRHospDr      = objHosp
	Set obj.CRStatDate    = StatDate
	Set obj.CREndDate     = EndDate
	Set obj.CRIsActive    = IsActive
	Set obj.CRActDate     = ActDate
	Set obj.CRActTime     = ActTime

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
/// CreatDate：   2021-09-29
/// Description:  删除手术分类75百分位信息
/// Table：       DHCHAI.IR.CRuleOperCatP75
/// Input：       aId : DHCHAI.IR.CRuleOperCatP75.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleOperCatP75).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleOperCatP75).%DeleteId(aId)
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CROperCatDr</Value>
</Value>
<Value name="3">
<Value>CROperMin</Value>
</Value>
<Value name="4">
<Value>CRHospGrpDr</Value>
</Value>
<Value name="5">
<Value>CRHospDr</Value>
</Value>
<Value name="6">
<Value>CRStatDate</Value>
</Value>
<Value name="7">
<Value>CREndDate</Value>
</Value>
<Value name="8">
<Value>CRIsActive</Value>
</Value>
<Value name="9">
<Value>CRActDate</Value>
</Value>
<Value name="10">
<Value>CRActTime</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.IR.CRuleOperCatP75D</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^MA.HAI.IR.CRuleOperCatP75D</IdLocation>
<IndexLocation>^MA.HAI.IR.CRuleOperCatP75I</IndexLocation>
<StreamLocation>^MA.HAI.IR.CRuleOperCatP75S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
