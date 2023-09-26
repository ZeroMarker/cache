Class DHCMed.CR.Project Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Property Code As %String(TRUNCATE = 1) [ Required ];

Property Description As %String(TRUNCATE = 1) [ Required ];

Property TemplateID As %String(TRUNCATE = 1) [ Required ];

Property Active As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N");

Property Resume As %String(TRUNCATE = 1);

Index IndexCode On Code [ Unique ];

Index IndexTemplateID On TemplateID;

Relationship ItemsChild As DHCMed.CR.ProjectItems [ Cardinality = children, Inverse = ParRef ];

ClassMethod LoadData()
{
	for i=1:1:10 {
		set obj = ##class(DHCMed.CR.Project).%New()
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
	//w ##class(DHCMed.CR.Project).UpdatePrj("1^P0001^EditDesc^T0001^Yes^")
	set RowId=$p(PrjString,"^",1)
	set Code=$p(PrjString,"^",2)
	set Description=$p(PrjString,"^",3)
	set TemplateID=$p(PrjString,"^",4)
	set Active=$p(PrjString,"^",5)
	set:Active["Y" Active="Y"
	set:Active["N" Active="N"
	set Resume=$p(PrjString,"^",6)
	
	set:RowId="" obj=##class(DHCMed.CR.Project).%New()
	set:RowId'="" obj=##class(DHCMed.CR.Project).%OpenId(+RowId)
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
	q:'$d(^DHCMed.CR.ProjectD(RowId)) ret
	s ret=$g(^DHCMed.CR.ProjectD(RowId))
	s ret=RowId_"^"_$li(ret,2)_"^"_$li(ret,3)_"^"_$li(ret,4)_"^"_$li(ret,5)_"^"_$li(ret,6)
	q ret
}

/// 创建者：刘宇辉
/// 功能：通过项目代码获取项目对象
/// w ##class(DHCMed.CR.Project).GetByCode("HDM","Y")
ClassMethod GetByCode(argCode As %String, argIsActive As %String) As DHCMed.CR.Project
{
	New (argCode,argIsActive)
	Set return=""
	Set argCode=$ZCVT(argCode,"U")
	Quit:argCode="" return
	Quit:'$d(^DHCMed.CR.ProjectI("IndexCode"," "_argCode)) return
	Set Rowid=""
	For {
		Set Rowid=$o(^DHCMed.CR.ProjectI("IndexCode"," "_argCode,Rowid))
		Quit:Rowid=""
		Set objPrj=##class(DHCMed.CR.Project).%OpenId(Rowid)
		Continue:'$IsObject(objPrj)
		Do objPrj.%Close()
		Set IsActive=objPrj.Active
		Continue:(argIsActive'="")&&(IsActive'=argIsActive)
		Set return=objPrj
	}
	Quit return
}

/// 创建者：刘宇辉
/// 功能：通过项目代码获取项目ID
/// w ##class(DHCMed.CR.Project).GetIdByCode("HDM","Y")
ClassMethod GetIdByCode(argCode As %String, argIsActive As %String) As %String
{
	New (argCode,argIsActive)
	Set return=""
	Set argCode=$ZCVT(argCode,"U")
	Quit:argCode="" return
	Quit:'$d(^DHCMed.CR.ProjectI("IndexCode"," "_argCode)) return
	Set Rowid=""
	For {
		Set Rowid=$o(^DHCMed.CR.ProjectI("IndexCode"," "_argCode,Rowid))
		Quit:Rowid=""
		Set objPrj=##class(DHCMed.CR.Project).%OpenId(Rowid)
		Continue:'$IsObject(objPrj)
		Do objPrj.%Close()
		Set IsActive=objPrj.Active
		Continue:(argIsActive'="")&&(IsActive'=argIsActive)
		Set return=Rowid
	}
	Quit return
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
<DataLocation>^DHCMed.CR.ProjectD</DataLocation>
<DefaultData>ProjectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CR.ProjectD</IdLocation>
<IndexLocation>^DHCMed.CR.ProjectI</IndexLocation>
<StreamLocation>^DHCMed.CR.ProjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
