/// 名称: DHCHAI.IR.CRuleRBAb
/// 描述: 影像学筛查标准
/// 编写者：zhufei
/// 编写日期: 2017-05-22
Class DHCHAI.IR.CRuleRBAb Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检查项目
Relationship ChildRBC As DHCHAI.IR.CRuleRBCode [ Cardinality = children, Inverse = Parref ];

/// 检查项目
Property BTRBCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 检查部位
Property BTRBPos As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 说明
Property BTRBNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 筛查标志（检查项目）
Property BTRBCFlag As %Boolean;

/// 检查项目索引
Index IndexBTRBCode On BTRBCode As Exact;

/// Creator：     zhoubo
/// CreatDate：   2017-08-02
/// Description:  根据ID取影像学筛查标准信息
/// Table：       DHCHAI.IR.CRuleRBAb
/// Input：       aId : DHCHAI.IR.CRuleRBAb.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleRBAb).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleRBAb
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleRBAb).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleRBAb).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-02
/// Description:  更新影像学筛查标准信息
/// Table：       DHCHAI.IR.CRuleRBAb
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleRBAb).Update("^ssfCode^检查部位^说的vgsgbeizhubeizhu^1","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID        = $p(aInputStr,aSeparete,1)
	Set RBCode    = $p(aInputStr,aSeparete,2)
	Set RBPos     = $p(aInputStr,aSeparete,3)
	Set RBNote    = $p(aInputStr,aSeparete,4)
	Set BTRBCFlag = +$p(aInputStr,aSeparete,5)
	Quit:(RBCode="")||(RBPos="") return
	Set RBCode = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(RBCode) //去掉特殊字符
	Set RBPos = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(RBPos)
	// 检查项目唯一性
	Set tID =$o(^DHCHAI.IR.CRuleRBAbI("IndexBTRBCode",RBCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	If ID="" {
		Set obj=##class(DHCHAI.IR.CRuleRBAb).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleRBAb).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTRBCode  = RBCode
	Set obj.BTRBPos   = RBPos
	Set obj.BTRBNote  = RBNote
	Set obj.BTRBCFlag = BTRBCFlag
	
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

/// Creator：     zhoubo
/// CreatDate：   2017-08-02
/// Description:  删除影像学筛查标准信息
/// Table：       DHCHAI.IR.CRuleRBAb
/// Input：       aId : DHCHAI.IR.CRuleRBAb.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleRBAb).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleRBAb).%DeleteId(aId)
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
<Data name="CRuleRBAbDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTRBCode</Value>
</Value>
<Value name="3">
<Value>BTRBPos</Value>
</Value>
<Value name="4">
<Value>BTRBNote</Value>
</Value>
<Value name="5">
<Value>BTRBCFlag</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CRuleRBAbD</DataLocation>
<DefaultData>CRuleRBAbDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CRuleRBAbD</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleRBAbI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleRBAbS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
