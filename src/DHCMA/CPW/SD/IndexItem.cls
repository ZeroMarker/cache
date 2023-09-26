Class DHCMA.CPW.SD.IndexItem Extends %Persistent
{

Relationship Parref As DHCMA.CPW.SD.IndexInfo [ Cardinality = parent, Inverse = ChildItem ];

/// 项目代号(A,B,C,D)
Property ItemAbbrev As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 项目ID
Property ItemId As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 指标字段 索引
Index IdxOfParr On (Parref, ItemId);

/// w ##class(DHCMA.CPW.SD.IndexItem).GetObjById(1)
ClassMethod GetObjById(Id As %String) As DHCMA.CPW.SD.IndexItem
{
	Quit:'##class(DHCMA.CPW.SD.IndexItem).%ExistsId(Id) ""
	Set obj=##Class(DHCMA.CPW.SD.IndexItem).%OpenId(Id)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.IndexItem).Update("223^94^4||39^A")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{

	Set return=0
	Quit:aInputStr="" return
	Set ^zqy2021=aInputStr	
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref           = $p(aInputStr,aSeparete,1)
	Set ID            	 = $p(aInputStr,aSeparete,2)
	Set ItemId         	 = $p(aInputStr,aSeparete,3)
	Set ItemAbbrev       = $p(aInputStr,aSeparete,4)
	
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.IndexItem).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.IndexItem).%OpenId(Parref_"||"_ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref      = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(Parref)
	Set obj.ItemId      = ItemId
	Set obj.ItemAbbrev  = ItemAbbrev
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

/// w ##class(DHCMA.CPW.SD.IndexItem).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	Set sc = ##class(DHCMA.CPW.SD.IndexItem).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// w ##class(DHCMA.CPW.SD.IndexItem).ImpUpdate("WS004^1^住院天数^B^CM-0-2-4-2")
ClassMethod ImpUpdate(aInputStr As %String, aSeparete As %String = "^") As %String
{
	Set return=0
	Quit:aInputStr="" return	
	Set ^zqya=$lb(aInputStr)	
	Set:$g(aSeparete)="" aSeparete="^"
	Set entityid		= $p(aInputStr,aSeparete,1)
	Set type			= $p(aInputStr,aSeparete,2)
	Set Parref      	= $p(aInputStr,aSeparete,3)
	Set ItemAbbrev		= $p(aInputStr,aSeparete,4)
	Set ItemId			= $p(aInputStr,aSeparete,5)
	Quit:entityid="" return
	Set entityidObj=##class(DHCMA.CPW.SD.QCEntity).GetObjByCode(entityid)
	Quit:'$IsObject(entityidObj) return
	Set entityid=entityidObj.%Id()
	Set ParrefID=##class(DHCMA.CPW.SD.IndexInfo).GetObjByTitle(entityid,Parref,0,type)
	Quit:ParrefID="" return
	Set ObjEntityItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjByVerCode("2",entityid,ItemId)
	Quit:'$IsObject(ObjEntityItem) return
	Set ID=$o(^DHCMA.CPW.SD.IndexItemI("IdxOfParr",ParrefID," "_ObjEntityItem.%Id(),0))
	If ID="" {	
		Set obj=##class(DHCMA.CPW.SD.IndexItem).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.IndexItem).%OpenId(ParrefID_"||"_ID)
	}
	Set obj.Parref      = ##class(DHCMA.CPW.SD.IndexInfo).GetObjById(ParrefID)
	Set obj.ItemId      = ObjEntityItem.%Id()
	Set obj.ItemAbbrev  = ItemAbbrev
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
<Data name="IndexItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemAbbrev</Value>
</Value>
<Value name="3">
<Value>ItemId</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("LinkItem")</DataLocation>
<DefaultData>IndexItemDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.IndexInfoC("LinkItem")</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.IndexItemI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.IndexItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
