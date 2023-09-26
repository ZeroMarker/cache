Class DHCMed.SS.ReportConfigItem Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship Parent As DHCMed.SS.ReportConfig [ Cardinality = parent, Inverse = ConfigItems ];

Property Code As %String;

Property Value1 As %String(MAXLEN = 500);

Property Value2 As %String(MAXLEN = 500);

ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.SS.ReportConfigItem).%New()
		} 
	else {
		set obj=##class(DHCMed.SS.ReportConfigItem).%OpenId(ID)
		}
	Set obj.Parent=##class(DHCMed.SS.ReportConfig).%OpenId($p(InStr,separete,2))
	set obj.Code=$p(InStr,separete,3)
	set obj.Value1=$p(InStr,separete,4)
	set obj.Value2=$p(InStr,separete,5)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

ClassMethod GetObjById(id As %String) As DHCMed.SS.ReportConfigItem
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SS.ReportConfigItem).%ExistsId(id) return
	set obj=##Class(DHCMed.SS.ReportConfigItem).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

ClassMethod Delete(RowID As %String)
{
	Quit ##class(DHCMed.SS.ReportConfigItem).%DeleteId(RowID)
}

Storage Default
{
<Data name="ReportConfigItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>""</Value>
</Value>
<Value name="3">
<Value>Value1</Value>
</Value>
<Value name="4">
<Value>Value2</Value>
</Value>
<Value name="5">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ConfigItems")</DataLocation>
<DefaultData>ReportConfigItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.ReportConfigC("ConfigItems")</IdLocation>
<IndexLocation>^DHCMed.SS.ReportConfigItemI</IndexLocation>
<StreamLocation>^DHCMed.SS.ReportConfigItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
