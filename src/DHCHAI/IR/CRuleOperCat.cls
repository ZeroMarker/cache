/// 名称: DHCHAI.IR.CRuleOperCat
/// 描述: 手术分类维护
/// 编写者：pylian
/// 编写日期: 2021-09-17
Class DHCHAI.IR.CRuleOperCat Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 关键词
Relationship ChildKeys As DHCHAI.IR.CRuleOperCatKeys [ Cardinality = children, Inverse = Parref ];

/// 手术分类名称
Property BTOperCat As %String(MAXLEN = 500, TRUNCATE = 1);

/// 手术分类类别(D诊断性操作，I介入治疗)
Property BTOperType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新用户
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexOperCat On BTOperCat As Exact;

/// Creator：     pylian
/// CreatDate：   2021-09-17
/// Description:  根据ID取手术分类维护信息
/// Table：       DHCHAI.IR.CRuleOperCat
/// Input：       aId : DHCHAI.IR.CRuleOperCat.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleOperCat).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleOperCat
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleOperCat).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleOperCat).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2021-09-17
/// Description:  更新手术分类维护信息
/// Table：       DHCHAI.IR.CRuleOperCat
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleOperCat).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID         = $p(aInputStr,aSeparete,1)
	Set OperCat	   = $p(aInputStr,aSeparete,2)
	Set OperType   = $p(aInputStr,aSeparete,3)
	Set IsActive   = +$p(aInputStr,aSeparete,4)
	Set ActDate    = $p(aInputStr,aSeparete,5)
	Set ActTime    = $p(aInputStr,aSeparete,6)
	Set ActUserDr  = $p(aInputStr,aSeparete,7)
	Quit:(OperCat="")||(OperType="") return
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set OperCat=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(OperCat) //去掉特殊字符

	Set tID =$o(^CF.MA.HAI.IR.CRuleOperCatI("IndexOperCat",OperCat,0))
	Quit:(tID'="")&&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.CRuleOperCat).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleOperCat).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTOperCat     = OperCat
	Set obj.BTOperType    = OperType
	Set obj.BTIsActive    = IsActive
	Set obj.BTActDate     = ActDate
	Set obj.BTActTime     = ActTime
	Set obj.BTActUser     = ActUserDr
	
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
/// CreatDate：   2021-09-17
/// Description:  删除手术分类维护信息
/// Table：       DHCHAI.IR.CRuleOperCat
/// Input：       aId : DHCHAI.IR.CRuleOperCat.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleOperCat).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	
	Set sc = ##class(DHCHAI.IR.CRuleOperCat).%DeleteId(aId)
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
<Value>BTOperCat</Value>
</Value>
<Value name="3">
<Value>BTOperType</Value>
</Value>
<Value name="4">
<Value>BTIsActive</Value>
</Value>
<Value name="5">
<Value>BTActDate</Value>
</Value>
<Value name="6">
<Value>BTActTime</Value>
</Value>
<Value name="7">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>^CF.MA.HAI.IR.CRuleOperCatD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.MA.HAI.IR.CRuleOperCatD</IdLocation>
<IndexLocation>^CF.MA.HAI.IR.CRuleOperCatI</IndexLocation>
<StreamLocation>^CF.MA.HAI.IR.CRuleOperCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
