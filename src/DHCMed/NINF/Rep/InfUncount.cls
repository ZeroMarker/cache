Class DHCMed.NINF.Rep.InfUncount Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// EpisodeID 指向Pa_Adm
Property EpisodeID As %String(TRUNCATE = 1);

/// 应报告科室 指向CT_Loc
Property ReportLoc As %String(TRUNCATE = 1);

/// 应报告人员 指向SS_User
Property ReportUser As %String(TRUNCATE = 1);

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

/// 有效状态
Property Active As %Boolean;

ClassMethod GetObjById(id As %String) As DHCMed.NINF.Rep.InfUncount
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Rep.InfUncount).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Rep.InfUncount).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// w ##class(DHCMed.NINF.Rep.InfUncount).Update("^1^2^3^Y^4","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.NINF.Rep.InfUncount).%New()
		} 
	else {
		set obj=##class(DHCMed.NINF.Rep.InfUncount).%OpenId(ID)
		}
	set:ID="" obj.EpisodeID=$p(InStr,separete,2)
	set obj.ReportLoc=$p(InStr,separete,3)
	set obj.ReportUser=$p(InStr,separete,4)
	set obj.Active=$p(InStr,separete,5)
	set obj.ResumeText=$p(InStr,separete,6)
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

Storage Default
{
<Data name="InfUncountDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>ReportLoc</Value>
</Value>
<Value name="4">
<Value>ReportUser</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Rep.InfUncountD</DataLocation>
<DefaultData>InfUncountDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Rep.InfUncountD</IdLocation>
<IndexLocation>^DHCMed.NINF.Rep.InfUncountI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.InfUncountS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
