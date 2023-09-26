/// 抗菌药物标准名称
Class DHCMA.CPW.SDMatch.AntiItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 类别
Property BTCatDr As DHCMA.CPW.SDMatch.Anticat [ Required ];

/// 英文名
Property EName As %String(MAXLEN = 500, TRUNCATE = 1);

/// 是否有效
Property IsActive As %Boolean;

/// 备注
Property Resume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IdxOfCode On BTCode;

Index IdxCat On BTCatDr;

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SDMatch.Anticat
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SDMatch.AntiItem).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SDMatch.AntiItem).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SDMatch.AntiItem).GetObjByCode("")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^DHCMA.CPW.SDMatch.AntiItemI("IdxOfCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SDMatch.AntiItem).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// w ##class(DHCMA.CPW.SDMatch.AntiItem).Update("")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID               = $p(aInputStr,aSeparete,1)
	Set Code             = $p(aInputStr,aSeparete,2)
	Set Desc             = $p(aInputStr,aSeparete,3)
	Set EName            = $p(aInputStr,aSeparete,4)
	Set Active           = $p(aInputStr,aSeparete,5)
	Set Resume           = $p(aInputStr,aSeparete,6)
	Set CatDr            = $p(aInputStr,aSeparete,7)
	Set tID=$o(^DHCMA.CPW.SDMatch.AntiItem("IdxOfCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2                
	If ID="" {
		Set obj=##class(DHCMA.CPW.SDMatch.AntiItem).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SDMatch.AntiItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.BTCode        = Code
	Set obj.BTDesc        = Desc
	Set obj.EName         = EName
	Set obj.IsActive      = Active
	Set obj.Resume        = Resume
	Set obj.BTCatDr       = ##class(DHCMA.CPW.SDMatch.Anticat).GetObjById(CatDr)
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
<Data name="AntiItemDefaultData">
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
<Value>BTCatDr</Value>
</Value>
<Value name="5">
<Value>EName</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SDMatch.AntiItemD</DataLocation>
<DefaultData>AntiItemDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SDMatch.AntiItemD</IdLocation>
<IndexLocation>^DHCMA.CPW.SDMatch.AntiItemI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SDMatch.AntiItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
