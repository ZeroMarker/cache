/// 重点患者管理子类型ID与临床上报模板关联
Class DHCMed.IMP.ImpRelationCR Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 指向DHCMed.CR.Project
/// 临床上报的项目ID
Property ProjectID As %Integer;

/// 重点患者的子类型ID
/// DHCMed.IMP.PatientTypeSub
Property SubTypeID As %Integer;

/// 是否有效
Property IsActive As %Boolean;

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

Index ProjectIDIndex On ProjectID As Exact;

Index SubTypeIDIndex On SubTypeID As Exact;

/// 通过临床上报项目ID、重点病人子类别ID
Index ProjectSubTypeIndex On (ProjectID As Exact, SubTypeID As Exact);

ClassMethod Update(arg As %String, separete As %String = "^") As %String
{
	s id=$p(arg,separete,1)
	s obj=""
	i id'="" d
	.i ##class(DHCMed.IMP.ImpRelationCR).%ExistsId(id)  d
	..s obj=##class(DHCMed.IMP.ImpRelationCR).%OpenId(id)
	i $IsObject(obj)=0  d
	.s obj=##class(DHCMed.IMP.ImpRelationCR).%New()
	s obj.ProjectID=$p(arg,separete,2)
	s obj.SubTypeID=$p(arg,separete,3)
	s obj.IsActive=+$p(arg,separete,4)
	s obj.ResumeText=$p(arg,separete,5)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	k obj
	quit id
}

Storage Default
{
<Data name="ImpRelationCRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IsActive</Value>
</Value>
<Value name="3">
<Value>ProjectID</Value>
</Value>
<Value name="4">
<Value>ResumeText</Value>
</Value>
<Value name="5">
<Value>SubTypeID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.IMP.ImpRelationCRD</DataLocation>
<DefaultData>ImpRelationCRDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.IMP.ImpRelationCRD</IdLocation>
<IndexLocation>^DHCMed.IMP.ImpRelationCRI</IndexLocation>
<StreamLocation>^DHCMed.IMP.ImpRelationCRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
