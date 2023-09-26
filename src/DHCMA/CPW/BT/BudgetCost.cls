/// 名称: DHCMA.CPW.BT.BudgetCost
/// 描述: 路径表单成本测算
/// 编写者：yankai
/// 编写日期: 2022-01-07
Class DHCMA.CPW.BT.BudgetCost Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 预算医嘱明细
Relationship ChildOrd As DHCMA.CPW.BT.BudgetOrderRec [ Cardinality = children, Inverse = BRParref ];

/// 预算分类费用明细
Relationship ChildDtl As DHCMA.CPW.BT.BudgetCostDtl [ Cardinality = children, Inverse = Parref ];

/// 申请表单指针
Property PathFormDr As DHCMA.CPW.BT.PathForm [ Required ];

/// 预算总费用
Property TotalCost As %Float;

/// 自费比例
Property SelfPayRatio As %Float;

/// 预算人（指向DHCMA.Util.EP.SSUser.OID）
Property BudgetUser As %String;

/// 预算日期
Property BudgetDate As %Date;

/// 预算时间
Property BudgetTime As %Time;

/// 表单指针索引（可视为唯一索引）
Index IdxofPathFormDr On PathFormDr As Exact;

/// Creator：     yankai
/// CreatDate：   2022-01-28
/// Description:  根据表单id获取对象
/// Table：       DHCMA.CPW.BT.BudgetCost
/// Input：       aId :  DHCMA.CPW.BT.BudgetCost.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.BudgetCost).GetObjByFormID(1)
ClassMethod GetObjByFormID(aFormId As %String) As %String
{
	New (aFormId)
	Set return=""
	Quit:aFormId="" return
	
	//此索引视为唯一索引，可根据其获取对象
	Set BudgetCostID=$o(^DHCMA.CPW.BT.BudgetCostI("IdxofPathFormDr",aFormId,""))
	Quit:BudgetCostID="" return
	Set objBudgetCost=##class(DHCMA.CPW.BT.BudgetCost).%OpenId(BudgetCostID)
	Quit:'$IsObject(objBudgetCost) return
	
	Quit objBudgetCost
}

/// Creator：     yankai
/// CreatDate：   2022-01-08
/// Description:  获取对象
/// Table：       DHCMA.CPW.BT.BudgetCost
/// Input：       aId :  DHCMA.CPW.BT.BudgetCost.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.BudgetCost).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.BudgetCost
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.BudgetCost).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.BudgetCost).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2022-01-08
/// Description:  更新信息
/// Table：       DHCMA.CPW.BT.BudgetCost
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.BudgetCost).Update("^83^12000.233^9!!1^")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set ID       		= $p(aInputStr,aSeparete,1)		//ID
	Set PathFormDr		= $p(aInputStr,aSeparete,2)		//测算表单
	Set TotalCost     	= $p(aInputStr,aSeparete,3)		//测算总费用
	Set BudgetUser		= $p(aInputStr,aSeparete,4)		//测算人
	Set SelfPayRatio	= $p(aInputStr,aSeparete,5)		//自费比值
	Set BudgetDate		= +$h
	Set BudgetTime		= $p($h,",",2)
	
	Set objPathForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(PathFormDr)
	Quit:'$IsObject(objPathForm) -2
	
	If ID="" {                                  				//根据ID判断是添加还是修改
		Set ID=$o(^DHCMA.CPW.BT.BudgetCostI("IdxofPathFormDr",PathFormDr,""),-1)		//每个表单只保存唯一测算记录
		If ID=""{
			Set obj=##class(DHCMA.CPW.BT.BudgetCost).%New()	
		}Else{
			Set obj=##class(DHCMA.CPW.BT.BudgetCost).%OpenId(ID)	
		}
	}Else{
		Set obj=##class(DHCMA.CPW.BT.BudgetCost).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PathFormDr		= objPathForm
	Set obj.TotalCost		= TotalCost
	Set obj.BudgetUser		= BudgetUser
	Set obj.BudgetDate		= BudgetDate
	Set obj.BudgetTime		= BudgetTime
	Set obj.SelfPayRatio	= SelfPayRatio
	
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
/// Table：       DHCMA.CPW.BT.BudgetCost
/// Input：       aId :  DHCMA.CPW.BT.BudgetCost.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.BudgetCost).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	Set sc = ##class(DHCMA.CPW.BT.BudgetCost).%DeleteId(aId)
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
<Data name="BudgetCostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PathFormDr</Value>
</Value>
<Value name="3">
<Value>TotalCost</Value>
</Value>
<Value name="4">
<Value>BudgetUser</Value>
</Value>
<Value name="5">
<Value>BudgetDate</Value>
</Value>
<Value name="6">
<Value>BudgetTime</Value>
</Value>
<Value name="7">
<Value>SelfPayRatio</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.BudgetCostD</DataLocation>
<DefaultData>BudgetCostDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.BudgetCostD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.BudgetCostI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.BudgetCostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
