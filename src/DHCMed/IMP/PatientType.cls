/// 名称：DHCMed.IMP.PatientType
/// 描述：重点患者大类
/// 创建者：李阳
/// 创建时间：2010-04-07
Class DHCMed.IMP.PatientType Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 重点患者大类代码
Property Code As %String(TRUNCATE = 1);

/// 大类描述
Property Description As %String(TRUNCATE = 1);

/// 是否活动
Property IsActive As %Boolean;

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

/// 代码索引
Index IndexOfCode On Code [ Unique ];

/// 图标路径、文件名称
/// Add By LiYang 2011-03-04
Property IconFileName As %String;

/// 禁用、终止状态图标路径、文件名称
/// Add By LiYang 2011-03-04
Property IconFileNameDisable As %String;

/// 查询所有大类
/// Modified By LiYang 2011-03-04 增加图标文件路径
Query QueryAll(IsActive As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Code:%String:代码,Description:%String:描述,IsActive:%String:活动,ResumeText:%String:备注,IconFileName:%String:图标,IconFileNameDisable:%String:终止状态图标")
{
	SELECT %ID,Code,Description,IsActive,ResumeText,IconFileName,IconFileNameDisable FROM PatientType WHERE (IsActive = :IsActive) OR (:IsActive = -1)
}

ClassMethod GetObjById(ID As %String)
{
	n (ID)
	q:ID="" ""
	q:$d(^DHCMed.IMP.PatientTypeD(ID))=0 ""
	s obj=##class(DHCMed.IMP.PatientType).%OpenId(ID)
	q obj
}

Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..%Id()_separete
	set return=return_..Code_separete
	set return=return_..Description_separete
	set return=return_..IsActive_separete
	set return=return_..ResumeText_separete
	//Modified By LiYang 2011-03-04 增加图标文件路径
	set return=return_..IconFileName_separete 
	set return=return_..IconFileNameDisable_separete
	q return
}

/// Creator：     李阳
/// CreatDate：   2010-04-08
/// Description:  根据ID重点患者大类信息
/// Input：       id:    DHCMed.IMP.PatientType.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.Patient).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
		d obj.%Close()
	}	
	quit return
}

/// Creator：     李阳
/// CreatDate：   2010-04-19
/// Description:  根据ID重点患者大类信息
/// Input：       id:    DHCMed.IMP.PatientType.ID
///               separete: 指定的分隔符
/// Return：      返回obj.%Id()
/// w ##class(DHCMed.Base.Patient).Update()
ClassMethod Update(arg As %String, separete As %String) As %String
{
	n (arg,separete)
	s id=$p(arg,separete,1)
	s obj=""
	i id'="" d
	.i ##class(DHCMed.IMP.PatientType).%ExistsId(id)  d
	..s obj=##class(DHCMed.IMP.PatientType).%OpenId(id)
	i $IsObject(obj)=0  d
	.s obj=##class(DHCMed.IMP.PatientType).%New()
	s obj.Code=$p(arg,separete,2)
	s obj.Description=$p(arg,separete,3)
	s obj.IsActive=+$p(arg,separete,4)
	s obj.ResumeText=$p(arg,separete,5)
	//Modified By LiYang 2011-03-04 增加图标文件路径
	s obj.IconFileName=$p(arg,separete,6) 
	s obj.IconFileNameDisable=$p(arg,separete,7)
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
<Data name="PatientTypeDefaultData">
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
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
<Value name="6">
<Value>IconFileName</Value>
</Value>
<Value name="7">
<Value>IconFileNameDisable</Value>
</Value>
</Data>
<DataLocation>^DHCMed.IMP.PatientTypeD</DataLocation>
<DefaultData>PatientTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.IMP.PatientTypeD</IdLocation>
<IndexLocation>^DHCMed.IMP.PatientTypeI</IndexLocation>
<StreamLocation>^DHCMed.IMP.PatientTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
