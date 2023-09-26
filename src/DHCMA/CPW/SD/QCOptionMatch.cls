/// 名称: DHCMA.CPW.SD.QCOptionMatch
/// 描述: 单病种质控项目选项对照
/// 编写者：fcz
/// 编写日期: 2018-09-10
Class DHCMA.CPW.SD.QCOptionMatch Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目字典
Property ItemOptionDr As DHCMA.CPW.SD.Dictionary;

/// 对照类型(1/2/3,按医嘱/按药品通用名/按药品分类)
Property OMType As %String;

/// 医嘱项ID
Property OMArcimID As %String;

/// 医嘱项名称
Property OMArcimDesc As %String;

/// 医嘱项对应药品通用名
Property OMPHCGeneric As %String;

/// 医嘱项对应药品分类
Property OMCategory As %String;

Index IndexOfItemOptionDr On ItemOptionDr;

/// w ##class(DHCMA.CPW.SD.QCOptionMatch).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCOptionMatch
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCOptionMatch).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCOptionMatch).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCOptionMatch).Update("2^^1^7103||1^剖宫产术^剖宫产术^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ItemOptionDr	 = $p(aInputStr,aSeparete,1)
	Set ID           	 = $p(aInputStr,aSeparete,2)
	Set OMType           = $p(aInputStr,aSeparete,3)	
	Set OMArcimID        = $p(aInputStr,aSeparete,4)
	Set OMArcimDesc      = $p(aInputStr,aSeparete,5)
	Set OMPHCGeneric     = $p(aInputStr,aSeparete,6)
    Set OMCategory       = $p(aInputStr,aSeparete,7)   
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.QCOptionMatch).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.QCOptionMatch).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.ItemOptionDr        =##class(DHCMA.CPW.SD.Dictionary).GetObjById(ItemOptionDr)
	Set obj.OMType        		= OMType
	Set obj.OMArcimID        	= OMArcimID
	Set obj.OMArcimDesc			= OMArcimDesc
	Set obj.OMPHCGeneric		= OMPHCGeneric
	Set obj.OMCategory    		= OMCategory
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

/// w ##class(DHCMA.CPW.SD.QCOptionMatch).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.SD.QCOptionMatch")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.SD.QCOptionMatch).%DeleteId(aId)
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
<Data name="QCOptionMatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemOptionDr</Value>
</Value>
<Value name="3">
<Value>OMType</Value>
</Value>
<Value name="4">
<Value>OMOrderID</Value>
</Value>
<Value name="5">
<Value>OMOrderDesc</Value>
</Value>
<Value name="6">
<Value>OMCommonName</Value>
</Value>
<Value name="7">
<Value>OMCategory</Value>
</Value>
<Value name="8">
<Value>OMArcimID</Value>
</Value>
<Value name="9">
<Value>OMArcimDesc</Value>
</Value>
<Value name="10">
<Value>OMPHCGeneric</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.QCOptionMatchD</DataLocation>
<DefaultData>QCOptionMatchDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.QCOptionMatchD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCOptionMatchI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCOptionMatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
