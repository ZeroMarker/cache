/// 描述: 单病种质控项目选项对照（标准抗菌药）
Class DHCMA.CPW.SD.QCOptionMatchAnti Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目字典
Property ItemOptionDr As DHCMA.CPW.SD.Dictionary;

/// 抗菌药物医嘱
Property AntiItem As DHCMA.CPW.SDMatch.AntiItem;

Index IndexOfOptionDr On ItemOptionDr;

/// w ##class(DHCMA.CPW.SD.QCOptionMatchAnti).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCOptionMatchAnti
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCOptionMatchAnti).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCOptionMatchAnti).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCOptionMatchAnti).Update("")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ItemOptionDr	 = $p(aInputStr,aSeparete,1)
	Set AntiItemDr       = $p(aInputStr,aSeparete,2)
	Set obj=##class(DHCMA.CPW.SD.QCOptionMatchAnti).%New()
	Quit:'$IsObject(obj) return
	Set obj.ItemOptionDr        = ##class(DHCMA.CPW.SD.Dictionary).GetObjById(ItemOptionDr)
	Set obj.AntiItem        	= ##class(DHCMA.CPW.SDMatch.AntiItem).GetObjById(AntiItemDr)
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

/// w ##class(DHCMA.CPW.SD.QCOptionMatchAnti).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.QCOptionMatchAnti).%DeleteId(aId)
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
<Data name="QCOptionMatchAntiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemOptionDr</Value>
</Value>
<Value name="3">
<Value>AntiItem</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.QCOptionMatchAntiD</DataLocation>
<DefaultData>QCOptionMatchAntiDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.QCOptionMatchAntiD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCOptionMatchAntiI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCOptionMatchAntiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
