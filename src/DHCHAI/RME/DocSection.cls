/// 文档段落
Class DHCHAI.RME.DocSection Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.RME.DocMaster [ Cardinality = parent, Inverse = ChildDS ];

Relationship ChildDW As DHCHAI.RME.DocResult [ Cardinality = children, Inverse = Parref ];

/// 文档段落分类
Property DSTypeDr As DHCHAI.RME.SectionType;

/// 文档段落内容
Property DSContent As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 文档段落层级编号
Property DSGroupNo As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Index IndexSectionTypeDr On (Parref, DSTypeDr);

Index IndexSectionGroupNo On (Parref, DSGroupNo);

/// Creator：     chenjb
/// CreatDate：   2017-08-09
/// Description:  根据ID取信息
/// Table：       DHCHAI.RME.DocSection
/// Input：       aId : ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.DocSection).GetObjById(Parref||1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.DocSection
{
	New (aId)
	Quit:'##class(DHCHAI.RME.DocSection).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.DocSection).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2017-08-09
/// Description:  更新信息
/// Table：       DHCHAI.RME.DocSection
/// Input：       各属性列表 ^分隔
/// 1 Parref 2 ID 3 DSTypeDr 4 DSContent 5 DSGroupNo
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.DocSection).Update("^DocType02^文档类型02","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref       = $p(aInputStr,aSeparete,1)
	Set ChildSub     = $p(aInputStr,aSeparete,2)
	Set DSTypeDr     = $p(aInputStr,aSeparete,3)
	Set DSContent    = $p(aInputStr,aSeparete,4)
	Set DSGroupNo    = $p(aInputStr,aSeparete,5)
	Quit:(Parref="")||(DSGroupNo="") return
	
	Set objParref=##class(DHCHAI.RME.DocMaster).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objSectionType=##class(DHCHAI.RME.SectionType).GetObjById(DSTypeDr)
	//Quit:'$IsObject(objSectionType) return
	
	If ChildSub="" {
		Set obj=##class(DHCHAI.RME.DocSection).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.DocSection).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref    = objParref
	Set obj.DSTypeDr  = objSectionType
	Set obj.DSContent = DSContent
	Set obj.DSGroupNo = DSGroupNo
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

/// Creator：     zhufei
/// CreatDate：   2017-10-13
/// Description:  删除文档段落
/// Table：       DHCHAI.RME.DocSection
/// Input：       aId : DHCHAI.RME.DocSection.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.DocSection).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.RME.DocSection).%DeleteId(aId)
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
<Data name="DocSectionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DSTypeDr</Value>
</Value>
<Value name="3">
<Value>DSContent</Value>
</Value>
<Value name="4">
<Value>DSGroupNo</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DS")</DataLocation>
<DefaultData>DocSectionDefaultData</DefaultData>
<IdLocation>{%%PARENT}("DS")</IdLocation>
<IndexLocation>^DHCHAI.RME.DocMasterI("DS")</IndexLocation>
<StreamLocation>^DHCHAI.RME.DocSectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
