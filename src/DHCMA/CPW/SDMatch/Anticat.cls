/// 抗菌药物大类
/// 解决抗菌药物医嘱对照问题
Class DHCMA.CPW.SDMatch.Anticat Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 英文名
Property EName As %String(MAXLEN = 500, TRUNCATE = 1);

/// 备注
Property Resume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IdxOfCode On BTCode;

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SDMatch.Anticat
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SDMatch.Anticat).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SDMatch.Anticat).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SDMatch.Anticat).GetObjByCode("")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^DHCMA.CPW.SDMatch.AnticatI("IdxOfCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// w ##class(DHCMA.CPW.SDMatch.Anticat).Update("")
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
	Set Resume           = $p(aInputStr,aSeparete,5)
	Set tID=$o(^DHCMA.CPW.SDMatch.AnticatI("IdxOfCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2                
	If ID="" {
		Set obj=##class(DHCMA.CPW.SDMatch.Anticat).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SDMatch.Anticat).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode        = Code
	Set obj.BTDesc        = Desc
	Set obj.EName         = EName
	Set obj.Resume        = Resume
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

ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SDMatch.Anticat).%DeleteId(aId)
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
<Data name="AnticatDefaultData">
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
<Value>EName</Value>
</Value>
<Value name="5">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SDMatch.AnticatD</DataLocation>
<DefaultData>AnticatDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SDMatch.AnticatD</IdLocation>
<IndexLocation>^DHCMA.CPW.SDMatch.AnticatI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SDMatch.AnticatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
