/// 抗菌药物医嘱与HIS医嘱对照
Class DHCMA.CPW.SDMatch.AntiItemMatch Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 抗菌药物医嘱
Property AntiItemDr As DHCMA.CPW.SDMatch.AntiItem;

/// 对照类型(1/2,按医嘱/按药品通用名)
Property OMType As %String;

/// 医嘱项ID
Property OMArcimID As %String;

/// 医嘱项名称
Property OMArcimDesc As %String;

/// 医嘱项对应药品通用名
Property OMPHCGeneric As %String;

Index IndexOfItemDr On AntiItemDr;

/// w ##class(DHCMA.CPW.SDMatch.AntiItemMatch).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SDMatch.AntiItemMatch
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SDMatch.AntiItemMatch).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SDMatch.AntiItemMatch).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SDMatch.AntiItemMatch).Update("258^^1^995||1^注射用头孢他啶[0.5g]^注射用头孢他啶")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return	

	Set:$g(aSeparete)="" aSeparete="^"
	Set ItemDr	 		 = $p(aInputStr,aSeparete,1)
	Set ID           	 = $p(aInputStr,aSeparete,2)
	Set OMType           = $p(aInputStr,aSeparete,3)	
	Set OMArcimID        = $p(aInputStr,aSeparete,4)
	Set OMArcimDesc      = $p(aInputStr,aSeparete,5)
	Set OMPHCGeneric     = $p(aInputStr,aSeparete,6)
	If ID="" {
		Set obj=##class(DHCMA.CPW.SDMatch.AntiItemMatch).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SDMatch.AntiItemMatch).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.AntiItemDr        	=##class(DHCMA.CPW.SDMatch.AntiItem).GetObjById(ItemDr)
	Set obj.OMType        		= OMType
	Set obj.OMArcimID        	= OMArcimID
	Set obj.OMArcimDesc			= OMArcimDesc
	Set obj.OMPHCGeneric		= OMPHCGeneric
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

/// w ##class(DHCMA.CPW.SDMatch.AntiItemMatch).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SDMatch.AntiItemMatch).%DeleteId(aId)
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
<Data name="AntiItemMatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AntiItemDr</Value>
</Value>
<Value name="3">
<Value>OMType</Value>
</Value>
<Value name="4">
<Value>OMArcimID</Value>
</Value>
<Value name="5">
<Value>OMArcimDesc</Value>
</Value>
<Value name="6">
<Value>OMPHCGeneric</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SDM.AntiMatchD</DataLocation>
<DefaultData>AntiItemMatchDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SDM.AntiItemMatchD</IdLocation>
<IndexLocation>^DHCMA.CPW.SDM.AntiMatchI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SDM.AntiMatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
