/// 名称: DHCMA.CPW.SD.QCIndex
/// 描述: 单病种质控指标
/// 编写者：fcz
/// 编写日期: 2018-09-10
Class DHCMA.CPW.SD.QCIndex Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.SD.QCEntity [ Cardinality = parent, Inverse = ChildIndex ];

/// 指标代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 指标描述
Property BTDesc As %String(MAXLEN = 200, TRUNCATE = 1);

/// 指标类别
Property BTIndexCat As %String(MAXLEN = 200, TRUNCATE = 1);

/// 指标报表链接
Property RaqName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 序号
Property BTIndNo As %String(MAXLEN = 200, TRUNCATE = 1);

/// 是否有效
Property IsActive As %Boolean;

Index IndexParref On Parref;

Index IndexCode On BTCode As Exact;

/// w ##class(DHCMA.CPW.SD.QCIndex).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCIndex
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCIndex).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCIndex).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCIndex).Update("14^^CS-1a^术前风险评估的分类统计表^指标统计^CS-1a.raq^2^1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ParrefId		= $p(aInputStr,aSeparete,1)
	Set ID				= $p(aInputStr,aSeparete,2)	
	Set BTCode 			= $p(aInputStr,aSeparete,3)
	Set BTDesc			= $p(aInputStr,aSeparete,4)
	Set IndexCat        = $p(aInputStr,aSeparete,5)
	Set RaqName         = $p(aInputStr,aSeparete,6)
	Set IndNo        	= $p(aInputStr,aSeparete,7)
	Set IsActive        = $p(aInputStr,aSeparete,8)
	if (ID="") {
		Set subID=$o(^DHCMA.CPW.SD.QCIndexI("IndexCode",BTCode,ParrefId,""))
		Set:subID'="" ID=ParrefId_"||"_subID
	}
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.QCIndex).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.QCIndex).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.Parref        	= ##class(DHCMA.CPW.SD.QCEntity).GetObjById(ParrefId)
	Set obj.BTCode        	= BTCode
	Set obj.BTDesc        	= BTDesc	
	Set obj.BTIndexCat		= IndexCat
	Set obj.RaqName			= RaqName
	Set obj.BTIndNo			= IndNo
	Set obj.IsActive    	= IsActive
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

/// w ##class(DHCMA.CPW.SD.QCIndex).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.QCIndex).%DeleteId(aId)
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
<Data name="QCIndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTIndexCat</Value>
</Value>
<Value name="5">
<Value>RaqName</Value>
</Value>
<Value name="6">
<Value>BTIndNo</Value>
</Value>
<Value name="7">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildIndex")</DataLocation>
<DefaultData>QCIndexDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.QCEntityC("ChildIndex")</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCIndexI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCIndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
