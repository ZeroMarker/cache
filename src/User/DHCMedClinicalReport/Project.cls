Class User.DHCMedClinicalReport.Project Extends %Persistent [ ClassType = persistent, ProcedureBlock, StorageStrategy = Default ]
{

Property Code As %String(TRUNCATE = 1) [ Required ];

Property Description As %String(TRUNCATE = 1) [ Required ];

Property TemplateID As %String(TRUNCATE = 1) [ Required ];

Property Active As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N");

Property Resume As %String(TRUNCATE = 1);

Index IndexCode On Code;

Index IndexTemplateID On TemplateID;

Relationship Supervisor As User.DHCMedClinicalReport.ProjectItems [ Cardinality = children, Inverse = PrjParRef ];

ClassMethod LoadData()
{
	for i=1:1:10 {
		set obj = ##class(User.DHCMedClinicalReport.Project).%New()
		set obj.Code = "Code"_i
		set obj.Description = "Description"_i
		set obj.TemplateID="TemplateID"_i
		set obj.Active="Y"
		set obj.Resume=""
		d obj.%Save()
		//set Id = obj.%Id()
		//w !,Id
		}
	//set obj = ##class(User.DHCMedCR.Project).%OpenId(Id)
}

ClassMethod UpdatePrj(PrjString) As %String
{
	//new (PrjString)  //error
	//w ##class(User.DHCMedClinicalReport.Project).UpdatePrj("1^P0001^EditDesc^T0001^Yes^")
	set RowId=$p(PrjString,"^",1)
	set Code=$p(PrjString,"^",2)
	set Description=$p(PrjString,"^",3)
	set TemplateID=$p(PrjString,"^",4)
	set Active=$p(PrjString,"^",5)
	set:Active["Y" Active="Y"
	set:Active["N" Active="N"
	set Resume=$p(PrjString,"^",6)
	
	set:RowId="" obj=##class(User.DHCMedClinicalReport.Project).%New()
	set:RowId'="" obj=##class(User.DHCMedClinicalReport.Project).%OpenId(+RowId)
	set obj.Code = Code
    set obj.Description = Description
    set obj.TemplateID=TemplateID
    set obj.Active=Active
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
	q:RowId="" ret
	q:'$d(^DHCMClin.ProjectD(RowId)) ret
	s ret=$g(^DHCMClin.ProjectD(RowId))
	s ret=RowId_"^"_$li(ret,2)_"^"_$li(ret,3)_"^"_$li(ret,4)_"^"_$li(ret,5)_"^"_$li(ret,6)
	q ret
}

Storage Default
{
<Data name="ProjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>TemplateID</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMClin.ProjectD</DataLocation>
<DefaultData>ProjectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMClin.ProjectD</IdLocation>
<IndexLocation>^DHCMClin.ProjectI</IndexLocation>
<StreamLocation>^User.DHC.ProjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
