Class User.DHCMedClinicalReport.ProjectItems Extends %Persistent [ ClassType = persistent, ProcedureBlock, StorageStrategy = Default ]
{

Relationship PrjParRef As User.DHCMedClinicalReport.Project [ Cardinality = parent, Inverse = Supervisor, Required ];

//Property ItemsChildSub As %Library.Float [ InitialExpression = {$i(^DHCMCPRJ($p(%d(0),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ItemsChildSub ];

//Property ItemsChildSub As %Library.Float [ InitialExpression = {$i(^DHCMCPRJ($p(%d(0),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ItemsChildSub ];

Property ElementCode As %String(TRUNCATE = 1) [ Required ];

Property CodeDesc As %String(TRUNCATE = 1) [ Required ];

Property Condition As %String(TRUNCATE = 1) [ Required ];

Property ComponentType As %String(TRUNCATE = 1) [ Required ];

Property Resume As %String(TRUNCATE = 1);

ClassMethod LoadData()
{
	for i=1:1:10 {
		set obj = ##class(User.DHCMedClinicalReport.ProjectItems).%New()
		//set obj.Code = "Code"_i
		//set obj.Description = "Description"_i
		//set obj.TemplateID="TemplateID"_i
		//set obj.Active="Y"
		set Parent = ##class(User.DHCMedClinicalReport.Project).%OpenId(1)
		set obj.PrjParRef= Parent
		set obj.ElementCode = "ElementCode"_i
		set obj.CodeDesc= "CodeDesc"_i
		set obj.Condition= "Condition"_i
		set obj.ComponentType= "ComponentType"_i
		set obj.Resume="Resume"_i
		d obj.%Save()
		//set Id = obj.%Id()
		//w !,Id
		}
	//set obj = ##class(User.DHCMedCR.Project).%OpenId(Id)
}

ClassMethod UpdatePrjItm(PrjItmString) As %String
{
	//new (PrjString)  //error 1||1
	//w ##class(User.DHCMedClinicalReport.ProjectItems).UpdatePrjItm("1^^Code^Desc^Condition^ConType^resNew")
	set Parref=$p(PrjItmString,"^",1)
	set ChildSub=$p(PrjItmString,"^",2)
	set ElementCode=$p(PrjItmString,"^",3)
	set CodeDesc=$p(PrjItmString,"^",4)
	set Condition=$p(PrjItmString,"^",5)
	set ComponentType=$p(PrjItmString,"^",6)
	set Resume=$p(PrjItmString,"^",7)
	
	set id=Parref_"||"_ChildSub
	set:ChildSub="" obj=##class(User.DHCMedClinicalReport.ProjectItems).%New()
	set:ChildSub'="" obj=##class(User.DHCMedClinicalReport.ProjectItems).%OpenId(id)
	set Parent = ##class(User.DHCMedClinicalReport.Project).%OpenId(Parref)
	set:ChildSub="" obj.PrjParRef= Parent
	set obj.ElementCode = ElementCode
    set obj.CodeDesc = CodeDesc
    set obj.Condition= Condition
    set obj.ComponentType= ComponentType
    set obj.Resume=Resume
	set rt=obj.%Save()
	If ($$$ISERR(rt)) {
		w !,"Error="_rt
		s id="-1"_rt
	}
	else
	{
		s id=obj.%Id()
		}
	d obj.%Close()
	q id
}

ClassMethod GetById(RowId As %String) As %String
{
	//n (RowId)
	s ret=""
	s Parref=$p(RowId,"||",1)
	s ChildSub=$p(RowId,"||",2)
	q:(Parref="")||(ChildSub="") ret
	q:'$d(^DHCMClin.ProjectItemsD(Parref,ChildSub)) ret
	s ret=$g(^DHCMClin.ProjectItemsD(Parref,ChildSub))
	s ret=$li(ret,2)_"^"_$li(ret,3)_"^"_$li(ret,4)_"^"_$li(ret,5)_"^"_$li(ret,6)
	q ret
}

Storage Default
{
<Data name="ProjectItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ElementCode</Value>
</Value>
<Value name="3">
<Value>CodeDesc</Value>
</Value>
<Value name="4">
<Value>Condition</Value>
</Value>
<Value name="5">
<Value>ComponentType</Value>
</Value>
<Value name="6">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMClin.ProjectItemsD</DataLocation>
<DefaultData>ProjectItemsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildPointer")</IdLocation>
<IndexLocation>^DHCMClin.ProjectItemsI</IndexLocation>
<StreamLocation>^User.DHC.ProjectItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
