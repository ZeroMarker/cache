/// 名称: DHCMA.CPW.BT.BudgetCostDtl
/// 描述: 路径表单成本测算明细类
/// 编写者：yankai
/// 编写日期: 2022-01-07
Class DHCMA.CPW.BT.BudgetCostDtl Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 父类
Relationship Parref As DHCMA.CPW.BT.BudgetCost [ Cardinality = parent, Inverse = ChildDtl ];

/// 病案首页子分类指针(指向表DHC_TarMCCateNew的TARMCCNew_RowId)
Property TarMCCateNewDr As %String;

/// 病案首页子分类金额
Property TarMCCateNewCost As %Float;

/// 病案首页大类指针(指向表DHC_TarMCNew的TARTMCNew_RowId)
Property TarMCNewDr As %String;

/// 父表-大类索引（便于统计大类计费）
Index IdxofParfTMNewDr On (Parref As Exact, TarMCNewDr As Exact);

/// 父表-子分类索引（可视为唯一索引）
Index IdxofParfTMCateNewDr On (Parref As Exact, TarMCCateNewDr As Exact);

/// Creator：     yankai
/// CreatDate：   2022-01-08
/// Description:  获取对象
/// Table：       DHCMA.CPW.BT.BudgetCostDtl
/// Input：       aId :  DHCMA.CPW.BT.BudgetCostDtl.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.BudgetCostDtl).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.BudgetCostDtl
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.BudgetCostDtl).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.BudgetCostDtl).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2022-01-08
/// Description:  更新信息
/// Table：       DHCMA.CPW.BT.BudgetCostDtl
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.BudgetCostDtl).Update("1^^13^3000.2342^10")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set Parref       		= $p(aInputStr,aSeparete,1)		//Parref
	Set ChildSub			= $p(aInputStr,aSeparete,2)		//subID
	Set TarMCCateNewDr		= $p(aInputStr,aSeparete,3)		//新首页费用子分类ID
	Set TarMCCateNewCost    = $p(aInputStr,aSeparete,4)		//测算首页子分类费用
	Set TarMCNewDr			= $p(aInputStr,aSeparete,5)		//新首页子分类所属大类ID
	
	Set objParref=##class(DHCMA.CPW.BT.BudgetCost).GetObjById(Parref)
	Quit:'$IsObject(objParref) -2
	
	If ChildSub="" {                                  								//根据ID判断是添加还是修改
		Set ChildSub=$o(^DHCMA.CPW.BT.BudgetCostI("DTL","IdxofParfTMCateNewDr",Parref,TarMCCateNewDr,""),-1)		//每个表单只针对子分类保存唯一测算记录
		If ChildSub=""{
			Set obj=##class(DHCMA.CPW.BT.BudgetCostDtl).%New()	
		}Else{
			Set obj=##class(DHCMA.CPW.BT.BudgetCostDtl).%OpenId(Parref_"||"_ChildSub)	
		}
	}Else{
		Set obj=##class(DHCMA.CPW.BT.BudgetCostDtl).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref				= objParref
	Set obj.TarMCCateNewDr		= TarMCCateNewDr
	Set obj.TarMCCateNewCost	= TarMCCateNewCost
	Set obj.TarMCNewDr			= TarMCNewDr
	
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

/// Creator：     yankai
/// CreatDate：   2022-01-08
/// Description:  删除申请记录
/// Table：       DHCMA.CPW.BT.BudgetCostDtl
/// Input：       aId :  DHCMA.CPW.BT.BudgetCostDtl.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.BudgetCostDtl).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	Set sc = ##class(DHCMA.CPW.BT.BudgetCostDtl).%DeleteId(aId)
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
<Data name="BudgetCostDtlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TarMCCateNewDr</Value>
</Value>
<Value name="3">
<Value>TarMCCateNewCost</Value>
</Value>
<Value name="4">
<Value>TarMCNewDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DTL")</DataLocation>
<DefaultData>BudgetCostDtlDefaultData</DefaultData>
<IdLocation>{%%PARENT}("DTL")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.BudgetCostI("DTL")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.BudgetCostDtlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
