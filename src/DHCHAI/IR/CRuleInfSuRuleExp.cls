/// 名称: DHCHAI.IR.CRuleInfSuRuleExp
/// 描述: 医院感染疑似筛查规则表达式
/// 编写者：zhufei
/// 编写日期: 2019-05-30
Class DHCHAI.IR.CRuleInfSuRuleExp Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.CRuleInfSuRule [ Cardinality = parent, Inverse = ChildExp ];

/// 项目名称(指向DHCHAI.IR.CRuleInfSuItem.BTItemDesc)
Property BTItemDesc As %String(MAXLEN = 1000, TRUNCATE = 1);

/// [输入类型=字典]值域设置 多值#分隔
Property BTInputDicSet As %String(MAXLEN = 1000, TRUNCATE = 1);

/// [输入类型=数值]筛查上限设置
Property BTInputMaxSet As %String(MAXLEN = 100, TRUNCATE = 1);

/// [输入类型=数值]筛查下限设置
Property BTInputMinSet As %String(MAXLEN = 100, TRUNCATE = 1);

/// [输入类型=项目]限定天数/持续天数设置
Property BTInputDaySet As %String(MAXLEN = 100, TRUNCATE = 1);

/// [输入类型=项目]限定次数设置
Property BTInputCntSet As %String(MAXLEN = 100, TRUNCATE = 1);

/// 输入说明
Property BTInputNote As %String(MAXLEN = 1000, TRUNCATE = 1);

/// add 2022-05-06 权重
Property BTWeight As %String;

/// add 2022-05-06 限定起始天数
Property BTInputSttDay As %String;

Index IdxOfItemDesc On (Parref, BTItemDesc);

/// Creator：     zhufei
/// CreatDate：   2019-05-30
/// Description:  根据ID取疑似筛查规则表达式
/// Table：       DHCHAI.IR.CRuleInfSuRuleExp
/// Input：       aId : DHCHAI.IR.CRuleInfSuRuleExp.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleInfSuRuleExp).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleInfSuRuleExp
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleInfSuRuleExp).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleInfSuRuleExp).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2019-05-30
/// Description:  根据ItemDesc取疑似筛查规则表达式
/// Table：       DHCHAI.IR.CRuleInfSuRuleExp
/// Input：       aItemDesc : 项目代码
/// Return：      返回obj
/// 备注：add 2022-05-12 增加aChildSub参数，解决增加权重后“项目名称”不唯一导致只取最后一条记录情况
/// w ##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs()
ClassMethod GetRuleExpArgs(aRuleDr As %String, aItemDesc As %String, aChildSub As %String = "") As %String
{
	New (aRuleDr,aItemDesc,aChildSub) 
	Set return=""
	Quit:(aRuleDr="")||(aItemDesc="") return
	
	Set xSub=0
	For {
		Set xSub=$o(^DHCHAI.IR.CRuleInfSuRuleI("EXP","IdxOfItemDesc",aRuleDr," "_$zcvt(aItemDesc,"U"),xSub))
		Quit:xSub=""
		Continue:(aChildSub'="")&(aChildSub'=xSub)
	
		Set objRuleExp=..GetObjById(aRuleDr_"||"_xSub)
		Continue:'$IsObject(objRuleExp)
		Set InputDic=objRuleExp.BTInputDicSet
		Set InputMax=objRuleExp.BTInputMaxSet
		Set InputMin=objRuleExp.BTInputMinSet
		Set InputDay=objRuleExp.BTInputDaySet
		Set InputCnt=objRuleExp.BTInputCntSet
		Set Weight  =objRuleExp.BTWeight
		Set SttDay=objRuleExp.BTInputSttDay
		If $p(return,"^",1)="" {
			Set $p(return,"^",1)=InputDic
		} Else {
			Set $p(return,"^",1)=$p(return,"^",1)_"#"_InputDic
		}
		Set $p(return,"^",2)=InputMax
		Set $p(return,"^",3)=InputMin
		Set $p(return,"^",4)=InputDay
		Set $p(return,"^",5)=InputCnt
		Set $p(return,"^",6)=Weight
		Set $p(return,"^",7)=SttDay
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-03-14
/// Description:  更新医院感染疑似筛查规则表达式
/// Table：       DHCHAI.IR.CRuleInfSuRuleExp
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleInfSuRuleExp).Update("^^C反应蛋白异常^^^^^^","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref      = $p(aInputStr,aSeparete,1)
	Set ChildSub    = $p(aInputStr,aSeparete,2)
	Set ItemDesc   	= $p(aInputStr,aSeparete,3)
	Set InputDicSet = $p(aInputStr,aSeparete,4)
	Set InputMaxSet = $p(aInputStr,aSeparete,5)
	Set InputMinSet = $p(aInputStr,aSeparete,6)
	Set InputDaySet = $p(aInputStr,aSeparete,7)
	Set InputCntSet = $p(aInputStr,aSeparete,8)
	Set InputNote 	= $p(aInputStr,aSeparete,9)
	Set Weight 	    = $p(aInputStr,aSeparete,10)
	Set SttDay      = $p(aInputStr,aSeparete,11)

	Set objParref=##class(DHCHAI.IR.CRuleInfSuRule).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
    
	If ChildSub="" {
		Set obj=##class(DHCHAI.IR.CRuleInfSuRuleExp).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleInfSuRuleExp).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return

	Set obj.Parref        = objParref
	Set obj.BTItemDesc    = ItemDesc   
	Set obj.BTInputDicSet = InputDicSet
	Set obj.BTInputMaxSet = InputMaxSet
	Set obj.BTInputMinSet = InputMinSet
	Set obj.BTInputDaySet = InputDaySet
	Set obj.BTInputCntSet = InputCntSet
	Set obj.BTInputNote   = InputNote  
	Set obj.BTWeight      = Weight
	Set obj.BTInputSttDay = SttDay
	
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
/// Description:  删除医院感染疑似筛查规则表达式
/// Table：       DHCHAI.IR.CRuleInfSuRuleExp
/// Input：       aId : DHCHAI.IR.CRuleInfSuRuleExp.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleInfSuRuleExp).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleInfSuRuleExp).%DeleteId(aId)
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
<Data name="CRuleInfSuRuleExpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTItemDesc</Value>
</Value>
<Value name="3">
<Value>BTInputDicSet</Value>
</Value>
<Value name="4">
<Value>BTInputMaxSet</Value>
</Value>
<Value name="5">
<Value>BTInputMinSet</Value>
</Value>
<Value name="6">
<Value>BTInputDaySet</Value>
</Value>
<Value name="7">
<Value>BTInputNote</Value>
</Value>
<Value name="8">
<Value>BTInputCntSet</Value>
</Value>
<Value name="9">
<Value>BTWeight</Value>
</Value>
<Value name="10">
<Value>BTInputSttDay</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EXP")</DataLocation>
<DefaultData>CRuleInfSuRuleExpDefaultData</DefaultData>
<IdLocation>{%%PARENT}("EXP")</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleInfSuRuleI("EXP")</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleInfSuRuleExpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
