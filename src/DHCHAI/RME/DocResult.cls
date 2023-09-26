/// 段落筛查结果
Class DHCHAI.RME.DocResult Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.RME.DocSection [ Cardinality = parent, Inverse = ChildDW ];

/// 筛查结果分类 未定义的为空
Property DRTypeDr As DHCHAI.RME.ResultType;

/// 筛查结果名称（归一词）
Property DRName As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 筛查结果名称（上位词）
Property DRFormal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 筛查结果内容
Property DRContext As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 筛查结果属性
Property DRPropertys As list Of DHCHAI.RME.DocProperty;

/// 筛查结果位置（格式：A,B;C,D）
Property DROffSet As %String(MAXLEN = 100, TRUNCATE = 1);

/// 同义词（多值;分割）
Property DRParserWords As %String(MAXLEN = 1000, TRUNCATE = 1);

/// Creator：     chenjb
/// CreatDate：   2017-08-09
/// Description:  根据ID取信息
/// Table：       DHCHAI.RME.DocResult
/// Input：       aId : ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.DocResult).GetObjById(Parref||1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.DocResult
{
	New (aId)
	Quit:'##class(DHCHAI.RME.DocResult).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.DocResult).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2017-08-09
/// Description:  更新信息
/// Table：       DHCHAI.RME.DocResult
/// Input：       各属性列表 ^分隔
/// 1 Parref 2 ID 3 DRTypeDr 4 DRName 5 DRContext 6 DRPropertys 7 DROffSet
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.DocResult).Update("^DocType02^文档类型02","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref       = $p(aInputStr,aSeparete,1)
	Set ChildSub     = $p(aInputStr,aSeparete,2)
	Set DRTypeDr     = $p(aInputStr,aSeparete,3)
	Set DRName       = $p(aInputStr,aSeparete,4)
	Set DRContext    = $p(aInputStr,aSeparete,5)
	Set Propertys    = $p(aInputStr,aSeparete,6)   //通过#号分割
	Set DROffSet     = $p(aInputStr,aSeparete,7)
	Set ParserWords  = $p(aInputStr,aSeparete,8)
	Set DRFormal     = $p(aInputStr,aSeparete,9)
	Quit:(Parref="") return
	
	Set objParref=##class(DHCHAI.RME.DocSection).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objResultType=##class(DHCHAI.RME.ResultType).GetObjById(DRTypeDr)
	//Quit:'$IsObject(objResultType) return
	
	If ChildSub="" {
		Set obj=##class(DHCHAI.RME.DocResult).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.DocResult).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref        = objParref
	Set obj.DRTypeDr      = objResultType
	Set obj.DRName        = DRName
	Set obj.DRFormal      = DRFormal
	Set obj.DRContext     = DRContext
	Set obj.DROffSet      = DROffSet
	Set obj.DRParserWords = ParserWords
	
	For indPro=1:1:$l(Propertys,"#") {
		Set tProStr=$p(Propertys,"#",indPro)
		Continue:tProStr=""
		
		Set ProTypeDr=$p(tProStr,"@",1)
		Set objProType=##class(DHCHAI.RME.PropertyType).GetObjById(ProTypeDr)
		Continue:'$IsObject(objProType)
		
		Set objPro=##class(DHCHAI.RME.DocProperty).%New()
		Set objPro.DPTypeDr= objProType
		Set objPro.DPName  = $p(tProStr,"@",2)
		Set objPro.DPValue = $p(tProStr,"@",3)
		Set objPro.DPUnit  = $p(tProStr,"@",4)
		Do obj.DRPropertys.Insert(objPro)
	}
	
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

Storage Default
{
<Data name="DocResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DRTypeDr</Value>
</Value>
<Value name="3">
<Value>DRName</Value>
</Value>
<Value name="4">
<Value>DRContext</Value>
</Value>
<Value name="5">
<Value>DRPropertys</Value>
</Value>
<Value name="6">
<Value>DROffSet</Value>
</Value>
<Value name="7">
<Value>DRParserWords</Value>
</Value>
<Value name="8">
<Value>DRFormal</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DR")</DataLocation>
<DefaultData>DocResultDefaultData</DefaultData>
<IdLocation>{%%PARENT}("DR")</IdLocation>
<IndexLocation>^DHCHAI.RME.DocMasterI("DR")</IndexLocation>
<StreamLocation>^DHCHAI.RME.DocResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
