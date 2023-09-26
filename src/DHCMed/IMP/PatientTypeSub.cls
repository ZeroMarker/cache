/// 名称：DHCMed.IMP.PatientTypeSub
/// 描述：重点患者小类
/// 创建者：李阳
/// 创建日期：2010-04-07
Class DHCMed.IMP.PatientTypeSub Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 所属大类，指向DHCMed.IMP.PatientType
Property ParentID As %Integer;

/// 代码
Property Code As %String(TRUNCATE = 1);

/// 小类描述
Property Description As %String(TRUNCATE = 1);

/// 标记颜色
Property MarkColor As %String(TRUNCATE = 1);

/// 是否需要审核
Property NeedCheck As %Boolean;

/// 是否有效
Property IsActive As %Boolean;

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

/// 图标路径、文件名称
/// Add By LiYang 2011-03-04
Property IconFileName As %String;

/// 禁用、终止状态图标路径、文件名称
/// Add By LiYang 2011-03-04
Property IconFileNameDisable As %String;

/// 指向DHCMed.IMP.PatientType的索引
Index ParentIDIndex On ParentID As Exact;

Index CodeIndex On Code [ Unique ];

/// 根据大类查询所属的子类
/// Modified By LiYang 2011-03-04 增加图标文件路径
Query QueryByParent(Parent As %String, IsActive As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Code:%String:代码,Description:%String:描述,IsActive:%String:活动,MarkColor:%String:标记颜色,NeedCheck:%String:需要审核,ParentID:%String,ResumeText:%String:备注,IconFileName:%String:图标,IconFileNameDisable:%String:终止状态图标")
{
SELECT %ID,Code,Description,IsActive,MarkColor,NeedCheck,ParentID,ResumeText,IconFileName,IconFileNameDisable FROM PatientTypeSub
WHERE (ParentID = :Parent) AND ((IsActive = :IsActive) OR (:IsActive = -1))
 ORDER BY Code
}

ClassMethod GetObjById(ID As %String)
{
	n (ID)
	q:ID="" ""
	q:$d(^DHCMed.IMP.PatientTypeSubD(ID))=0 ""
	s obj=##class(DHCMed.IMP.PatientTypeSub).%OpenId(ID)
	q obj
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
	}	
	quit return
}

Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..%Id()_separete
	set return=return_..ParentID_separete
	set return=return_..Code_separete
	set return=return_..Description_separete
	set return=return_..MarkColor_separete
	set return=return_..NeedCheck_separete
	set return=return_..IsActive_separete
	set return=return_..ResumeText_separete
	//Modified By LiYang 2011-03-04 增加图标文件路径
	set return=return_..IconFileName_separete
	set return=return_..IconFileNameDisable_separete	
	q return
}

ClassMethod Update(arg As %String, separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	s id=$p(arg,separete,1)
	s obj=""
	i id'=""  d
	.i ##class(DHCMed.IMP.PatientTypeSub).%ExistsId(id)  d
	..s obj=##class(DHCMed.IMP.PatientTypeSub).%OpenId(id)
	i $IsObject(obj)=0  d
	.s obj=##class(DHCMed.IMP.PatientTypeSub).%New()
	s obj.Code=$p(arg,separete,2)
	s obj.ParentID=$p(arg,separete,3)
	s obj.Description=$p(arg,separete,4)
	s obj.IsActive=$p(arg,separete,5)
	s obj.NeedCheck=$p(arg,separete,6)	
	s obj.MarkColor=$p(arg,separete,7)
	s obj.ResumeText=$p(arg,separete,8)
	//Modified By LiYang 2011-03-04 增加图标文件路径
	s obj.IconFileName=$p(arg,separete,9) 
	s obj.IconFileNameDisable=$p(arg,separete,10)	
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
<Data name="PatientTypeSubDefaultData">
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
<Value>MarkColor</Value>
</Value>
<Value name="6">
<Value>NeedCheck</Value>
</Value>
<Value name="7">
<Value>ParentID</Value>
</Value>
<Value name="8">
<Value>ResumeText</Value>
</Value>
<Value name="9">
<Value>IconFileName</Value>
</Value>
<Value name="10">
<Value>IconFileNameDisable</Value>
</Value>
</Data>
<DataLocation>^DHCMed.IMP.PatientTypeSubD</DataLocation>
<DefaultData>PatientTypeSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.IMP.PatientTypeSubD</IdLocation>
<IndexLocation>^DHCMed.IMP.PatientTypeSubI</IndexLocation>
<StreamLocation>^DHCMed.IMP.PatientTypeSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
