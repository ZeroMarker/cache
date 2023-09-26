/// 名称: DHCHAI.IR.CRuleOperCatKeys
/// 描述: 手术分类关键词维护
/// 编写者：pylian
/// 编写日期: 2021-11-3
Class DHCHAI.IR.CRuleOperCatKeys Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 手术名称/分类
Relationship Parref As DHCHAI.IR.CRuleOperCat [ Cardinality = parent, Inverse = ChildKeys ];

/// 关键词类型（手术名称、ICD9编码）
Property BTKeyType As %String(DISPLAYLIST = ",KEY,ICD9", VALUELIST = ",K,I");

/// 包含关键词/ICD9
Property BTIncludeKey As %String(MAXLEN = 500, TRUNCATE = 1);

/// 排除关键词/ICD9（除……外）
Property BTExcludeKeys As %String(MAXLEN = 500, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新用户
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexKeyType On BTKeyType As Exact;

Index IndexOperCat On Parref;

Index IndexOperCatKey On (Parref, BTIncludeKey As Exact);

/// Creator：     pylian
/// CreatDate：   2021-09-17
/// Description:  根据ID取手术分类关键词维护信息
/// Table：       DHCHAI.IR.CRuleOperCatKeys
/// Input：       aId : DHCHAI.IR.CRuleOperCatKeys.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleOperCatKeys).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleOperCatKeys
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleOperCatKeys).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleOperCatKeys).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2021-09-17
/// Description:  更新手术分类关键词维护信息
/// Table：       DHCHAI.IR.CRuleOperCatKeys
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleOperCatKeys).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref     = $p(aInputStr,aSeparete,1)
	Set ChildSub   = $p(aInputStr,aSeparete,2)
	Set KeyType    = $p(aInputStr,aSeparete,3)
	Set IncludeKey = $p(aInputStr,aSeparete,4)
	Set ExcludeKeys = $p(aInputStr,aSeparete,5)
	Set IsActive   = +$p(aInputStr,aSeparete,6)
	Set ActDate    = $p(aInputStr,aSeparete,7)
	Set ActTime    = $p(aInputStr,aSeparete,8)
	Set ActUserDr  = $p(aInputStr,aSeparete,9)
	Quit:(Parref="")||(KeyType="")||(IncludeKey="") return
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
    
    Set IncludeKey=$tr(IncludeKey,"；",";")
    Set ExcludeKeys=$tr(ExcludeKeys,"；",";")
    
	Set objParref=##class(DHCHAI.IR.CRuleOperCat).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	//包含关键词唯一性
	Set tChildSub =$o(^CF.MA.HAI.IR.CRuleOperCatI("KEYS","IndexOperCatKey",Parref,IncludeKey,0))
	Quit:(tChildSub'="")&&(ChildSub'=tChildSub) -2
	
	If ChildSub="" {
		Set obj=##class(DHCHAI.IR.CRuleOperCatKeys).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleOperCatKeys).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref		= objParref
	Set obj.BTKeyType     = KeyType
	Set obj.BTIncludeKey  = IncludeKey
	Set obj.BTExcludeKeys = ExcludeKeys
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
/// Description:  删除手术分类关键词维护信息
/// Table：       DHCHAI.IR.CRuleOperCatKeys
/// Input：       aId : DHCHAI.IR.CRuleOperCatKeys.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleOperCatKeys).DeleteById(1||1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleOperCatKeys).%DeleteId(aId)
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
<Value>BTKeyType</Value>
</Value>
<Value name="3">
<Value>BTIncludeKey</Value>
</Value>
<Value name="4">
<Value>BTExcludeKeys</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTActDate</Value>
</Value>
<Value name="7">
<Value>BTActTime</Value>
</Value>
<Value name="8">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("KEYS")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("KEYS")</IdLocation>
<IndexLocation>^CF.MA.HAI.IR.CRuleOperCatI("KEYS")</IndexLocation>
<StreamLocation>^CF.MA.HAI.IR.CRuleOperCatKeysS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
