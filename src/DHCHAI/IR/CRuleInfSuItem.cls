/// 名称: DHCHAI.IR.CRuleInfSuItem
/// 描述: 医院感染疑似筛查规则项目
/// 编写者：zhufei
/// 编写日期: 2019-05-30
Class DHCHAI.IR.CRuleInfSuItem Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目名称
Property BTItemDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目别名
Property BTItemDesc2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目分类
Property BTCategory As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// [输入类型=字典]值域标签
Property BTInputDicTab As %String(MAXLEN = 100, TRUNCATE = 1);

/// [输入类型=数值、项目]筛查上限标签
Property BTInputMaxTab As %Boolean;

/// [输入类型=数值、项目]筛查下限标签
Property BTInputMinTab As %Boolean;

/// [输入类型=项目]限定天数/持续天数标签
Property BTInputDayTab As %Boolean;

/// [输入类型=项目]限定次数标签
Property BTInputCntTab As %Boolean;

/// 输入说明
Property BTInputNote As %String(MAXLEN = 1000, TRUNCATE = 1);

Index IdxOfItemDesc On BTItemDesc;

Index IdxOfCategory On BTCategory As Exact;

/// Creator：     zhufei
/// CreatDate：   2019-05-30
/// Description:  根据ID取疑似筛查规则项目
/// Table：       DHCHAI.IR.CRuleInfSuItem
/// Input：       aId : DHCHAI.IR.CRuleInfSuItem.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleInfSuItem).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleInfSuItem
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleInfSuItem).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleInfSuItem).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2022-03-14
/// Description:  更新医院感染疑似筛查规则项目
/// Table：       DHCHAI.IR.CRuleInfSuItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleInfSuItem).Update("3^症状或体征(病程)^^症状或体征^^1^1^1^1^","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID        	= $p(aInputStr,aSeparete,1)
	Set ItemDesc   	= $p(aInputStr,aSeparete,2)
	Set ItemDesc2  	= $p(aInputStr,aSeparete,3)
	Set Category  	= $p(aInputStr,aSeparete,4)
	Set InputDicTab = $p(aInputStr,aSeparete,5)
	Set InputMaxTab = $p(aInputStr,aSeparete,6)
	Set InputMinTab = $p(aInputStr,aSeparete,7)
	Set InputDayTab = $p(aInputStr,aSeparete,8)
	Set InputCntTab = $p(aInputStr,aSeparete,9)
	Set InputNote 	= $p(aInputStr,aSeparete,10)
	Quit:(ItemDesc="")||(Category="") return
	
	Set ItemDesc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(ItemDesc) //去掉特殊字符
	Set tID=$o(^DHCHAI.IR.CRuleInfSuItemI("IdxOfItemDesc"," "_$zcvt(ItemDesc,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2
		
	If ID="" {
		Set obj=##class(DHCHAI.IR.CRuleInfSuItem).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleInfSuItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.BTItemDesc    = ItemDesc   
	Set obj.BTItemDesc2   = ItemDesc2  
	Set obj.BTCategory    = Category   
	Set obj.BTInputDicTab = InputDicTab
	Set obj.BTInputMaxTab = InputMaxTab
	Set obj.BTInputMinTab = InputMinTab
	Set obj.BTInputDayTab = InputDayTab
	Set obj.BTInputCntTab = InputCntTab
	Set obj.BTInputNote   = InputNote  

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
/// CreatDate：   2022-03-14
/// Description:  删除医院感染疑似筛查规则项目
/// Table：       DHCHAI.IR.CRuleInfSuItem
/// Input：       aId : DHCHAI.IR.CRuleInfSuItem.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleInfSuItem).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleInfSuItem).%DeleteId(aId)
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
<Data name="CRuleInfSuItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTItemDesc</Value>
</Value>
<Value name="3">
<Value>BTItemDesc2</Value>
</Value>
<Value name="4">
<Value>BTCategory</Value>
</Value>
<Value name="5">
<Value>BTInputDicTab</Value>
</Value>
<Value name="6">
<Value>BTInputMaxTab</Value>
</Value>
<Value name="7">
<Value>BTInputMinTab</Value>
</Value>
<Value name="8">
<Value>BTInputDayTab</Value>
</Value>
<Value name="9">
<Value>BTInputCntTab</Value>
</Value>
<Value name="10">
<Value>BTInputNote</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CRuleInfSuItemD</DataLocation>
<DefaultData>CRuleInfSuItemDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CRuleInfSuItemD</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleInfSuItemI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleInfSuItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
